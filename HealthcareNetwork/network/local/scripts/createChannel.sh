#!/bin/bash

# imports
. scripts/envVar.sh
. scripts/utils.sh

CHANNEL_NAME="$1"
DELAY="$2"
MAX_RETRY="$3"
VERBOSE="$4"
: ${CHANNEL_NAME:="defaultchannel"}
: ${DELAY:="3"}
: ${MAX_RETRY:="5"}
: ${VERBOSE:="false"}
CHANNEL_PROFILE="$5"

if [ ! -d "channel-artifacts" ]; then
	mkdir channel-artifacts
fi

createChannelTx() {
	configtxgen -profile ${CHANNEL_PROFILE} -outputCreateChannelTx ./channel-artifacts/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME
	res=$?
	
	verifyResult $res "Failed to generate channel configuration transaction..."
}

createChannel() {
	ORG=$1
	setGlobals 0 $ORG
	# Poll in case the raft leader is not set yet
	local rc=1
	local COUNTER=1
	while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ]; do
		sleep $DELAY
		
		peer channel create -o localhost:1100 -c $CHANNEL_NAME --ordererTLSHostnameOverride orderer1 -f ./channel-artifacts/${CHANNEL_NAME}.tx --outputBlock $BLOCKFILE --tls --cafile $ORDERER1_CA >&log.txt
		res=$?
		
		let rc=$res
		COUNTER=$(expr $COUNTER + 1)
	done
	cat log.txt
	verifyResult $res "Channel creation failed"
}

# joinChannel ORG
joinChannel() {
	FABRIC_CFG_PATH=$PWD/config/
	PEER=$1
	ORG=$2
	setGlobals $PEER $ORG
	local rc=1
	local COUNTER=1
	## Sometimes Join takes time, hence retry
	while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ]; do
		sleep $DELAY
		
		peer channel join -b $BLOCKFILE >&log.txt
		res=$?
		
		let rc=$res
		COUNTER=$(expr $COUNTER + 1)
	done
	cat log.txt
	verifyResult $res "After $MAX_RETRY attempts, peer${PEER}.${ORG} has failed to join channel '$CHANNEL_NAME' "
}

setAnchorPeer() {
	ORG=$1
	docker exec cli ./scripts/setAnchorPeer.sh $ORG $CHANNEL_NAME
}

FABRIC_CFG_PATH=${PWD}/configtx

## Create channeltx
infoln "Generating channel create transaction '${CHANNEL_NAME}.tx'"
createChannelTx

FABRIC_CFG_PATH=$PWD/config/
BLOCKFILE="./channel-artifacts/${CHANNEL_NAME}.block"

if [ "$CHANNEL_NAME" = "hcarechannel" ]; then
	## Create channel
	infoln "Creating channel ${CHANNEL_NAME}"
	createChannel hospital
	successln "Channel '$CHANNEL_NAME' created"
	## Join all the peers to the hcarechannel
    infoln "Joining hospital peer 0 to the hcarechannel..."
	joinChannel 0 hospital
    infoln "Joining hospital peer 1 to the hcarechannel..."
	joinChannel 1 hospital
    infoln "Joining pharmacy peer 0 to the hcarechannel..."
	joinChannel 0 pharmacy
    infoln "Joining pharmacy peer 1 to the hcarechannel..."
	joinChannel 1 pharmacy
    infoln "Joining laboratory peer 0 to the hcarechannel..."
	joinChannel 0 laboratory
    infoln "Joining laboratory peer 1 to the hcarechannel..."
	joinChannel 1 laboratory
	## Set the anchor peers for each org in the channel
	infoln "Setting anchor peer for hospital to the hcarechannel..."
	setAnchorPeer hospital
	infoln "Setting anchor peer for pharmacy to the hcarechannel..."
	setAnchorPeer pharmacy
	infoln "Setting anchor peer for laboratory to the hcarechannel..."
	setAnchorPeer laboratory

else
	errorln "Channel name unknown"
fi

successln "Channel '$CHANNEL_NAME' joined"

