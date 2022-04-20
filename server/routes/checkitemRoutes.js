var express = require('express');
var router = express.Router();
var cModel = require("../models/checkitemModel");

router.post('/',async function(req, res, next) {
    let newItem = req.body;
    let result = await cModel.insertChecklistItem(newItem);
    res.status(result.status).send(result.result);
});

router.delete('/:id/delete',async function(req, res, next) {
    let id = req.params.id;
    let result = await cModel.removeItem(id);
    res.status(result.status).send(result.result);
});

router.put('/:id/updatename', async function(req, res, next) {
    let id = req.params.id;
    let data = req.body;
    let result = await cModel.updateCheckitemName(id,data);
    res.status(result.status).send(result.result);
});

router.put('/:id/updatecheck', async function(req, res, next) {
    let id = req.params.id;
    let result = await cModel.updateCheckitemCheck(id);
    res.status(result.status).send(result.result);
});

module.exports = router;