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

/*----- CHECKLIST -----*/

module.exports.getUserChecklist = async function(id) {
  try {
      let sql = "select list_id, list_name, list_main, SUM(item_check) as checks "+
      "from checklist "+
      "inner join users "+
      "on user_id_FK = user_id "+
      "inner join check_item "+
      "on list_id_FK = list_id "+
      "where user_id = $1 "+
      "group by list_id";
      let result = await pool.query(sql,[id]);
      if (result.rows.length > 0) 
          return { status:200, result:result.rows };
      else return {status: 404, result: {msg: "No checklists associated"}};
  } catch(err) {
      console.log(err);
      return {status:500, result: err};
  }
}