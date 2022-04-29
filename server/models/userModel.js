var pool = require("./connection");

/*----- USER DATA -----*/

module.exports.login = async (user) => {
  try {
    const { code, password } = user;
    //convert code to int
    
    const sql = `get the user specified by credentials`;

    let result = await pool.query(sql, [code]);

    if (result.rowCount <= 0) {
      return { status: 400, result: { msg: "Wrong code" } };
    }

    result = result.rows[0];

    // TODO uncomment if we use bcrypt. passwords can be randomly generated per patient
    //const match = await bcrypt.compare(password, result.usr_password);

    //if (!match) {
    if (result.usr_password != password) {
      return { status: 400, result: { msg: "Wrong password" } };
    }

    delete result.usr_password;

    return { status: 200, result };
  } catch (error) {
    return { status: 500, result: error };
  }
};

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

// WE MAY WANT TO CREATE A cardiacDataModel and activitiesModel

/*----- USER CARDIAC DATA -----*/

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

/*----- USER CHECKLIST -----*/

module.exports.getChecklistItems = async function (id) {
  try {
    let sql = "select item_id, item_name, item_check " +
      "from checklist  " +
      "where user_id_fk = $1";
    let result = await pool.query(sql, [id]);
    if (result.rows.length > 0)
      return { status: 200, result: result.rows };
    else return { status: 404, result: { msg: "No items" } };
  } catch (err) {
    console.log(err);
    return { status: 500, result: err };
  }
}

