var express = require('express');
var router = express.Router();
var cModel = require("../models/checklistModel");

router.get('/:id/items', async function(req, res, next) {
    let id = req.params.id;
    console.log("Sending items of checklist with id "+id);
    let result = await cModel.getItemFromChecklist(id);
    res.status(result.status).send(result.result);
});

router.post('/',async function(req, res, next) {
    let newChecklist = req.body;
    let result = await cModel.insertChecklist(newChecklist);
    res.status(result.status).send(result.result);
});

router.delete('/:id/delete',async function(req, res, next) {
    let id = req.params.id;
    let result = await cModel.removeChecklist(id);
    res.status(result.status).send(result.result);
});

router.put('/:id/updatename', async function(req, res, next) {
    let id = req.params.id;
    let data = req.body;
    let result = await cModel.updateChecklistName(id,data);
    res.status(result.status).send(result.result);
});

router.put('/:id/updatemain', async function(req, res, next) {
    let id = req.params.id;
    let result = await cModel.updateChecklistMain(id);
    res.status(result.status).send(result.result);
});

module.exports = router;