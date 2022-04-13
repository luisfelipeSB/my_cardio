//const pool = require("./connection");
const bcrypt = require("bcrypt");
const saltRounds = 10;

module.exports.getUser = async () => {
  try {
    let result = 'user data'
    return { status: 200, result };
  } catch (error) {
    return { status: 500, result: error };
  }
};

module.exports.addUser = async () => {
  try {
    let result = 'user data'
    return { status: 200, result };
  } catch (error) {
    return { status: 500, result: error };
  }
};

// WE MAY HAVE TO CREATE A cardiacDataModel and activitiesModel

/*----- CARDIAC DATA -----*/

module.exports.getUserCardiacData = async (uid) => {
  try {
    let result = 'user cardiac data'
    return { status: 200, result };
  } catch (error) {
    return { status: 500, result: error };
  }
};

module.exports.addUserCardiacData = async (uid, data) => {
  try {
    let c = classify(data)
    let result = 'added user cardiac data and registered detected risks (if any)' + c
    return { status: 200, result };
  } catch (error) {
    return { status: 500, result: error };
  }
};

module.exports.getUserCardiacRisks = async (uid) => {
  try {
    let result = 'ANN classifications, refers to cardiacdata tables'
    return { status: 200, result };
  } catch (error) {
    return { status: 500, result: error };
  }
};

async function classify(data) {
  let classification = 0
  //ANN model goes here
  return classification
}

/*----- ACTIVITIES -----*/

module.exports.getUserActivities = async (uid) => {
  try {
    let result = 'user activities list'
    return { status: 200, result };
  } catch (error) {
    return { status: 500, result: error };
  }
};

module.exports.addUserActivity = async (uid) => {
  try {
    let result = 'add to user activities list'
    return { status: 200, result };
  } catch (error) {
    return { status: 500, result: error };
  }
};