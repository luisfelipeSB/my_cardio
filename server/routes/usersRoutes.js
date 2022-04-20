const express = require("express");
const userModel = require("../models/userModel");
const router = express.Router();

router.get("/:id", async (req, res) => {
  const id = req.params.id;
  const { status, result } = await userModel.getUser(id);

  res.status(status).send(result);
});

router.post("/", async (req, res) => {
  const user = req.body;
  const { status, result } = await userModel.addUser(user);

  res.status(status).send(result);
});

/*----- CARDIAC DATA -----*/

router.get("/:id/cardiacdata", async (req, res) => {
  const id = req.params.id;
  const { status, result } = await userModel.getUserCardiacData(id);

  res.status(status).send(result);
});

router.post("/:id/cardiacdata", async (req, res) => {
  const data = req.body;
  const { status, result } = await userModel.addUserCardiacData(data);

  res.status(status).send(result);
});

router.get("/:id/cardiacdata/risks", async (req, res) => {
  const id = req.params.id;
  const { status, result } = await userModel.getUserCardiacRisks(id);

  res.status(status).send(result);
});

/*----- CHECKLISTS -----*/

router.get('/:id/checklists', async function(req, res, next) {
  let id = req.params.id;
  console.log("Sending checklists of user with id "+id);
  let result = await uModel.getUserChecklist(id);
  res.status(result.status).send(result.result);
});

module.exports = router;