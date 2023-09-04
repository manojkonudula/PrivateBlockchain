const express = require('express');
const router = express.Router();
const log4js = require('log4js');
const logger = log4js.getLogger('user');
const config = require('../../config/constants.json');
logger.level = config.logLevel;
const patientService = require('../fabricGateway/patients');
const helper = require('../fabricOps/helper')

router.post('/add', async (req, res) => {
    try {
        response = await patientService.add(req);
        if (response.status === 'SUCCESS') {
            return res.status(200).send(response);
        } else if (response.status === 'DUPLICATE') {
            return res.status(409).send(response);
        } else if (response.status === 'ERROR') {
            return res.status(422).send(response);
        } else {
            return res.status(400).send(response);
        }

    } catch (error) {
        return res.status(401).send(error.toString());
    }
});

router.post('/search', async (req, res) => {
    try {
        response = await patientService.search(req);

        if (response.status === 'SUCCESS') {
            return res.status(200).send(response);
        } else if (response.status === 'ERROR') {
            return res.status(502).send(response);
        } else {
            return res.status(400).send(response);
        }

    } catch (error) {
        return res.status(401).send(error.toString());
    }
});


router.post('/update', async (req, res) => {
    try {
        response = await patientService.update(req);
        return res.status(200).send(response);
    } catch (error) {
        return res.status(401).send(error.toString());
    }
});

router.post('/getone', async (req, res) => {
    try {
        response = await patientService.getOne(req);
        return res.status(200).send(response);
    } catch (error) {
        return res.status(401).send(error.toString());
    }
});

router.post('/deleterecord', async (req, res) => {
    try {
        response = await patientService.deleteRecord(req);
        return res.status(200).send(response);
    } catch (error) {
        return res.status(401).send(error.toString());
    }
});

router.get('/getall', async (req, res) => {
    try {
        response = await patientService.getAll(req);
        return res.status(200).send(response);
    } catch (error) {
        return res.status(401).send(error.toString());
    }
});

router.post('/addprivate', async (req, res) => {
    try {
        response = await patientService.addPrivate(req);
        return res.status(200).send(response);
    } catch (error) {
        return res.status(401).send(error.toString());
    }
});

router.post('/getpvtdata', async (req, res) => {
    try {
        response = await patientService.getPvtData(req);
        return res.status(200).send(response);
    } catch (error) {
        return res.status(401).send(error.toString());
    }
});

router.post('/getipfsfile', async (req, res) => {
    try {
        response = await patientService.getIpfsFile(req);
        return res.status(200).send(response);
    } catch (error) {
        return res.status(401).send(error.toString());
    }
});


module.exports = router;

