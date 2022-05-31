var pool = require("./connection");

module.exports.login = async function (user) {
  try {
    let sql = "select * from dnt_doente where codigo = $1";
    let result = await pool.query(sql, [user.codigo]);
    
    if (result.rows.length > 0 && result.rows[0].falecido == "N" && user.password == 123) //password simulada
      return { status: 200, result: result.rows[0] };
    else return { status: 401, result: { msg: "Incorrect credentials" } };
  } catch (err) {
    console.log(err);
    return { status: 500, result: err };
  }
}

module.exports.getProfile = async function (id) {
  try {
    let sql = "select * from dnt_doente where codigo = $1";
    let result = await pool.query(sql, [id]);
    
    if (result.rows.length > 0)
      return { status: 200, result: result.rows[0] };
    else return { status: 404, result: { msg: "User not found" } };
  } catch (err) {
    console.log(err);
    return { status: 500, result: err };
  }
}

/*----- CARDIAC DATA -----*/

module.exports.getUserCardiacData = async (uid, tid) => {
  try {
    let sql = `
    select rmt_measure.instant as Instante, rmt_measure.value as Valor
    from rmt_measure
    inner join amd_acto_medico
    on rmt_measure.medical_act = amd_acto_medico.codigo
    inner join amd_tipo_acto_medico
    on amd_tipo_acto_medico.codigo = amd_acto_medico.tipo_acto_medico
    inner join rmt_device_type_measure_type
    on rmt_device_type_measure_type.id = rmt_measure.device_type_measure_type
    inner join rmt_device_type
    on rmt_device_type.id = rmt_device_type_measure_type.device_type
    inner join rmt_measure_type
    on rmt_measure_type.id = rmt_device_type_measure_type.measure_type
    where amd_acto_medico.doente = $1 and rmt_measure_type.description = $2
    order by instante;
    `
    let type = ''
    switch (parseInt(tid)) {
      case 1:
        type = 'Heart Rate'
        break
      
      case 2:
        type = 'Steps'
        break
      case 3:
        type = 'Distance'
        break
      case 4:
        type = 'Calories'
        break

      case 19:
        type = 'Diastolic Blood Pressure'
        break
      case 20:
        type = 'Systolic Blood Pressure'
        break
      
      case 21:
        type = 'Weight'
        break
      case 22:
        type = 'Fat Free Mass'
        break
      case 23:
        type = 'Fat Ratio'
        break
      case 24:
        type = 'Fat Mass'
        break

      default:
        break
    }

    if (type !== '') {
      let result = await pool.query(sql, [uid, type]);
      if (result.rows.length > 0) {
        return { status: 200, result: result }
      } else {
        return { status: 404 }
      }
    } else {
      return { status: 400 }
    }
  } catch (error) {
    return { status: 500, result: error };
  }
};

module.exports.getUserCardiacRisks = async (uid) => {
  try {
    let result = `risks`
    return { status: 200, result };
  } catch (error) {
    return { status: 500, result: error };
  }
};

/*----- CHECKLIST -----*/

module.exports.getChecklistItems = async function (id) {
  try {
    let sql = 
      `select item_id, item_name, item_check, item_category
      from checklist
      where user_id_fk = $1
      order by item_category`;
    let result = await pool.query(sql, [id]);
    if (result.rows.length > 0)
      return { status: 200, result: result.rows };
    else return { status: 404, result: { msg: "No items" } };
  } catch (err) {
    console.log(err);
    return { status: 500, result: err };
  }
}

