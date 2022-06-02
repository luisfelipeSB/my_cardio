var express = require('express');
var router = express.Router();
var pModel = require("../models/patientModel");

router.get('/:id/measure/:type', async function(req, res, next) {
    let id = req.params.id;
    let type = req.params.type;
    console.log("Sending patient with id "+id);
    let result = await pModel.getPatientMeasures(id,type);
    res.status(result.status).send(result.result);
  });

  router.get('/:id/measure/:type/flags', async function(req, res, next) {
    let id = req.params.id;
    let type = req.params.type;
    console.log("Sending patient with id "+id);
    let result = await pModel.getPatientMeasuresFlags(id,type);
    res.status(result.status).send(result.result);
  });

module.exports = router;