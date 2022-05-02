var express = require('express');
var router = express.Router();
var cModel = require("../models/checklistModel");

router.post('/additem',async function(req, res, next) {
    let newItem = req.body;
    let result = await cModel.insertChecklistItem(newItem);
    res.status(result.status).send(result.result);
});

router.put('/item/:id/updatename', async function(req, res, next) {
    let id = req.params.id;
    let data = req.body;
    let result = await cModel.updateChecklistItemName(id,data);
    res.status(result.status).send(result.result);
});

router.delete('/item/:id/delete',async function(req, res, next) {
    let id = req.params.id;
    let result = await cModel.removeChecklistItem(id);
    res.status(result.status).send(result.result);
});

router.put('/item/:id/updatecheck', async function(req, res, next) {
    let id = req.params.id;
    let result = await cModel.updateChecklistItemCheck(id);
    res.status(result.status).send(result.result);
});

router.post('/model',async function(req, res, next) {
    let data = req.body;
    let result = await cModel.insertModel(data);
    res.status(result.status).send(result.result);
});

module.exports = router;