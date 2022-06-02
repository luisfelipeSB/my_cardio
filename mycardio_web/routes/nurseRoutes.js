var express = require('express');
var router = express.Router();
var uModel = require("../models/nurseModel");

router.get('/', async function(req, res, next) {
    let result = await uModel.getAllUsers();
    res.status(result.status).send(result.result);
});

router.post('/login',async function(req, res, next) {
    let nome = req.body.nome;
    let password = req.body.password;
    let result = await uModel.login(nome,password);
    res.status(result.status).send(result.result);
});

router.get('/:id', async function(req, res, next) {
    let id = req.params.id;
    console.log("Sending nurse with id "+id);
    let result = await uModel.getUserById(id);
    res.status(result.status).send(result.result);
});

router.get('/:id/patients', async function(req, res, next) {
    let id = req.params.id;
    console.log("Sending nurse with id "+id);
    let result = await uModel.getNurseInCharge(id);
    res.status(result.status).send(result.result);
  });

router.post('/addflag',async function(req, res, next) {
    let newFlag = req.body;
    let result = await uModel.insertFlag(newFlag);
    res.status(result.status).send(result.result);
});

 





module.exports = router;