var express = require('express');
var router = express.Router();
var userModel = require("../models/userModel");

router.post('/login', async function (req, res, next) {
  let user = req.body;
  let result = await userModel.login(user);
  res.status(result.status).send(result.result);
});

router.get('/:id', async function (req, res, next) {
  let id = req.params.id;
  console.log("Sending user " + id + " profile data");
  let result = await userModel.getProfile(id);
  res.status(result.status).send(result.result);
});

/*----- CHECKLIST -----*/

router.get('/:id/checklist/items', async function (req, res, next) {
  let id = req.params.id;
  console.log("Sending checklist items of user with id " + id);
  let result = await userModel.getChecklistItems(id);
  res.status(result.status).send(result.result);
});

/*----- CARDIAC DATA -----*/

/*
router.get("/:id/cardiacdata", async (req, res) => {
  const id = req.params.id;
  const { status, result } = await userModel.getUserCardiacData(id);
  console.log("Sending user " + id + " cardiac data");
  res.status(status).send(result);
});
*/

router.get("/:id/cardiacdata/:type", async (req, res) => {
  const id = req.params.id;
  const type = req.params.type;
  const { status, result } = await userModel.getUserCardiacData(id, type);
  console.log("Sending user " + id + " cardiac data of type " + type);
  res.status(status).send(result);
});

router.get("/:id/cardiacdata/risks", async (req, res) => {
  const id = req.params.id;
  const { status, result } = await userModel.getUserCardiacRisks(id);

  res.status(status).send(result);
});

module.exports = router;
