const invoke = require('../fabricOps/invoke');
const query = require('../fabricOps/query')
const config = require('../../config/constants');
const crypto = require('../utils/cryptography');
const ipfs_util = require('../utils/ipfs_service');

const add = async (req) => {
    try {
        let username = req.headers.userid;
        let orgName = req.headers.org;
        const result = await invoke.invokeTransaction(config.channelName, config.chaincodeName, "AddPatient", req.body, username, orgName);
        return (result);
    } catch (error) {
        throw error.message.toString();
    }
}

const search = async (req) => {
    try {
        let username = req.headers.userid;
        let orgName = req.headers.org;
        let payloadForSmartcontract = [(JSON.stringify(req.body))];
        const result = await query.queryChaincode(config.channelName, config.chaincodeName, payloadForSmartcontract, "QueryByPartialKey", username, orgName);
        return (result);
    } catch (error) {
        throw error.message.toString();
    }
}

const update = async (req) => {
    try {
        let username = req.headers.userid;
        let orgName = req.headers.org;

        const result = await invoke.invokeTransaction(config.channelName, config.chaincodeName, "UpdatePatient", req.body, username, orgName);
        return (result);
    } catch (error) {
        throw error.message.toString();
    }
}

const getOne = async (req) => {
    try {
        let username = req.headers.userid;
        let orgName = req.headers.org;

        let payloadForSmartcontract = [];
        payloadForSmartcontract.push(JSON.stringify(req.body));
        const result = await query.queryChaincode(config.channelName, config.chaincodeName, payloadForSmartcontract, "ReadPatient", username, orgName);
        return (result);
    } catch (error) {
        throw error.message.toString();
    }
}

const deleteRecord = async (req) => {
    try {
        let username = req.headers.userid;
        let orgName = req.headers.org;

        const result = await invoke.invokeTransaction(config.channelName, config.chaincodeName, "DeletePatient", req.body, username, orgName);
        return (result);
    } catch (error) {
        throw error.message.toString();
    }
}

const getAll = async (req) => {
    try {
        let username = req.headers.userid;
        let orgName = req.headers.org;

        const result = await query.queryChaincode(config.channelName, config.chaincodeName, null, "GetAllPatients", username, orgName);
        return (result);
    } catch (error) {
        throw error.message.toString();
    }
}

const addPrivate = async (req) => {
    try {
        let username = req.headers.userid;
        let orgName = req.headers.org;

        const payload = await processPvtDataRequest(req);
        const result = await invoke.invokeTransaction(config.channelName, config.chaincodeName, "AddPatientPvtData", payload, username, orgName);
        return (result);
    } catch (error) {
        throw error.message.toString();
    }
}

const processPvtDataRequest = async (req) => {
    const params = JSON.parse(req.body.params);

    var payload = params

    if (req.files) {
        const files = req.files.file;

        if (files.length) {
            for (var i = 0; i < files.length; i++) {
                files[i].data = crypto.encrypt(files[i].data);
            }
        } else {
            files.data = crypto.encrypt(files.data);
        }

        ipfs_json = await ipfs_util.uploadToIPFS(files)
        payload = ({ ...params, fileLocations: ipfs_json })
    } 

    return payload
}

const getPvtData = async (req) => {
    try {
        let username = req.headers.userid;
        let orgName = req.headers.org;

        let payload = [];
        payload.push(JSON.stringify(req.body));
        const result = await query.queryChaincode(config.channelName, config.chaincodeName, payload, "QueryPatientPvtRecordById", username, orgName);
        return (result);
    } catch (error) {
        throw error.message.toString();
    }
}

const getIpfsFile = async (req) => {
    try {
        const file_buffer = await ipfs_util.getIpfsFile(req.body.props.cid);
        const decrypt_buffer = crypto.decrypt(file_buffer);
        return (decrypt_buffer);
    } catch (error) {
        throw error.message.toString();
    }
}

module.exports = {
    add,
    search,
    update,
    getOne,
    deleteRecord,
    getAll,
    addPrivate,
    getPvtData,
    getIpfsFile
}
