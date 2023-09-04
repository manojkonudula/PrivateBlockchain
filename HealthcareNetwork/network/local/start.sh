
# bring down the current network
# ./network.sh down

# Pull the images
# ./bootstrap.sh 2.4.9 1.5.6

# bring up the network
./network.sh up -ca -s couchdb

# create the hcarechannel
./network.sh createChannel -c hcarechannel -p DefaultChannel

# package and install 'hcarechannel' chaincode on all org nodes
./network.sh deployCC -ccn hcarecc -ccp ../../chaincode -ccl go -ccsd true

# deploy chaincode hcarecc on hcarechannel

# Uncomment if chaincode initialization required
# ./network.sh deployCC -c defaultchannel -ccn hcarecc -ccp ../../chaincode -ccl go -cci Init -ccsp true
./network.sh deployCC -c hcarechannel -ccn hcarecc -ccp ../../chaincode -ccl go -ccsp true


