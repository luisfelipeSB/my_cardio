const { type } = require("express/lib/response");
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

module.exports.getMedicalRecord = async function (id) {
  try {
    let sql = "select * from dnt_doente where codigo = $1";
    let result = await pool.query(sql, [id]);

    result.rows[0].nome = null
    result.rows[0].tipo_sanguineo = null
    result.rows[0].peso = null
    result.rows[0].altura = null

    let weight = await this.getUserRecentCardiacData(id, 21);
    let height = await this.getUserRecentCardiacData(id, 29);

    if (weight.hasOwnProperty('result'))
      result.rows[0].peso = weight.result.valor

    if (height.hasOwnProperty('result'))
      result.rows[0].altura = height.result.valor

    if (result.rows.length > 0)
      return { status: 200, result: result.rows[0] };
    else return { status: 404, result: { msg: "User not found" } };
  } catch (err) {
    console.log(err);
    return { status: 500, result: err };
  }
}

/*----- USER NOTIFICATIONS -----*/

module.exports.getUserNotifications = async function (id) {
  try {
    let measurementsPerDOY = await this.getMeasurementsPerDOY(id)
    let risksPerDOY = await this.getRisksPerDOY(id)

    let result = {}
    let permitted = true

    if (measurementsPerDOY.hasOwnProperty('result')) {
      result.measurementsPerDOY = measurementsPerDOY.result.rows
    } else {
      permitted = false
    }
    if (risksPerDOY.hasOwnProperty('result')) {
      result.risksPerDOY = risksPerDOY.result.rows
    } else {
      permitted = false
    }

    if (permitted) {
      return { status: 200, result: result };
    } else return { status: 404, result: { msg: "User not found" } };
  } catch (err) {
    console.log(err);
    return { status: 500, result: err };
  }
}

module.exports.getMeasurementsPerDOY = async (uid) => {
  try {

    // Getting from the past two years for demonstration purposes only

    let sql = `
    select date_part('doy', rmt_measure.instant) as day_of_year, count(rmt_measure.value) as count
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
    where amd_acto_medico.doente = $1
    and rmt_measure.instant + interval '2' year >= date_trunc('year', current_date) and
        rmt_measure.instant + interval '2' year < current_date
    group by day_of_year
    order by day_of_year desc;
    `

    let result = await pool.query(sql, [uid]);
    if (result.rows.length > 0) {
      return { status: 200, result: result }
    } else {
      return { status: 404 }
    }
  } catch (error) {
    return { status: 500, result: error };
  }
};

module.exports.getRisksPerDOY = async (uid) => {
  try {

    // Getting from the past two years for demonstration purposes only

    let sql = `
    select date_part('doy', instant) as day_of_year, count(value) as count
    from measure_flag
    inner join rmt_measure 
    on rmt_measure.id = measure_flag.rmt_measure_FK 
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
    where amd_acto_medico.doente = $1
    and rmt_measure.instant + interval '2' year >= date_trunc('year', current_date) and
        rmt_measure.instant + interval '2' year < current_date
    group by day_of_year
    order by day_of_year desc;
    `

    let result = await pool.query(sql, [uid]);
    if (result.rows.length > 0) {
      return { status: 200, result: result }
    } else {
      return { status: 404 }
    }
  } catch (error) {
    return { status: 500, result: error };
  }
};

/*----- USER STATISTICS -----*/

module.exports.getUserStatsSummary = async function (id) {
  try {
    let totalMeasurements = await this.getUserStatsTotalMeasurements(id)
    let lastMeasurement = await this.getUserStatsLastMeasurement(id)
    let remoteDevices = await this.getUserStatsRemoteDevices(id)
    let activitiesCompleted = await this.getUserStatsActivitiesCompleted(id)
    let totalMeasurementFlags = await this.getUserStatsTotalMeasurementFlags(id)
    let lastMeasurementFlag = await this.getUserStatsLastMeasurementFlag(id)

    /*
    console.log('----------- TM -----------')
    console.log(totalMeasurements)
    console.log('----------- LM -----------')
    console.log(lastMeasurement)
    console.log('----------- RD -----------')
    console.log(remoteDevices)
    console.log('----------- AC -----------')
    console.log(activitiesCompleted)
    */

    let result = {}
    let permitted = true

    if (totalMeasurements.hasOwnProperty('result')) {
      result.totalMeasurements = totalMeasurements.result.count
    } else {
      permitted = false
    }
    if (lastMeasurement.hasOwnProperty('result')) {
      result.lastMeasurement = lastMeasurement.result.instant
    } else {
      permitted = false
    }
    if (remoteDevices.hasOwnProperty('result')) {
      result.remoteDevices = remoteDevices.result
    } else {
      permitted = false
    }
    if (activitiesCompleted.hasOwnProperty('result')) {
      result.activitiesCompleted = activitiesCompleted.result.count
    } else {
      permitted = false
    }
    if (totalMeasurementFlags.hasOwnProperty('result')) {
      result.totalMeasurementFlags = totalMeasurementFlags.result.count
    } else {
      permitted = false
    }
    if (lastMeasurementFlag.hasOwnProperty('result')) {
      result.lastMeasurementFlag = lastMeasurementFlag.result.instant
    } else {
      permitted = false
    }

    if (permitted)
      return { status: 200, result: result };
    else return { status: 404, result: { msg: "User not found" } };
  } catch (err) {
    console.log(err);
    return { status: 500, result: err };
  }
}

module.exports.getUserStatsTotalMeasurements = async function (id) {
  try {
    let sql = `
    select count(*)
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
    where amd_acto_medico.doente = $1;
    `;
    let result = await pool.query(sql, [id]);

    if (result.rows.length > 0)
      return { status: 200, result: result.rows[0] };
    else return { status: 404, result: { msg: "User not found" } };
  } catch (err) {
    console.log(err);
    return { status: 500, result: err };
  }
}

module.exports.getUserStatsLastMeasurement = async function (id) {
  try {
    let sql = `
    select rmt_measure.instant
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
    where amd_acto_medico.doente = $1
    order by rmt_measure.instant desc limit 1;
    `;
    let result = await pool.query(sql, [id]);

    if (result.rows.length > 0)
      return { status: 200, result: result.rows[0] };
    else return { status: 404, result: { msg: "User not found" } };
  } catch (err) {
    console.log(err);
    return { status: 500, result: err };
  }
}

module.exports.getUserStatsRemoteDevices = async function (id) {
  try {
    let sql = `
    select distinct rmt_device_type.description
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
    where amd_acto_medico.doente = $1;
    `;
    let result = await pool.query(sql, [id]);

    if (result.rows.length > 0)
      return { status: 200, result: result.rows };
    else return { status: 404, result: { msg: "User not found" } };
  } catch (err) {
    console.log(err);
    return { status: 500, result: err };
  }
}

module.exports.getUserStatsActivitiesCompleted = async function (id) {
  try {
    let sql = `
    select count(*) filter (where item_check = true)
    from checklist
    where user_id_fk = $1;
    `;
    let result = await pool.query(sql, [id]);

    if (result.rows.length > 0)
      return { status: 200, result: result.rows[0] };
    else return { status: 404, result: { msg: "User not found" } };
  } catch (err) {
    console.log(err);
    return { status: 500, result: err };
  }
}

module.exports.getUserStatsTotalMeasurementFlags = async function (id) {
  try {
    let sql = `
    select count(*)
    from measure_flag
    inner join rmt_measure 
    on rmt_measure.id = measure_flag.rmt_measure_FK 
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
    where amd_acto_medico.doente = $1;
    `;
    let result = await pool.query(sql, [id]);

    if (result.rows.length > 0)
      return { status: 200, result: result.rows[0] };
    else return { status: 404, result: { msg: "User not found" } };
  } catch (err) {
    console.log(err);
    return { status: 500, result: err };
  }
}

module.exports.getUserStatsLastMeasurementFlag = async function (id) {
  try {
    let sql = `
    select rmt_measure.instant
    from measure_flag
    inner join rmt_measure 
    on rmt_measure.id = measure_flag.rmt_measure_FK 
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
    where amd_acto_medico.doente = $1
    order by instant desc limit 1;
    `;
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

      case 29:
        type = 'Height'
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

module.exports.getUserRecentCardiacData = async (uid, tid) => {
  try {
    let sql = `
    select rmt_measure.value as Valor
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
    order by rmt_measure.instant desc limit 1;
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

      case 29:
        type = 'Height'
        break

      default:
        break
    }

    if (type !== '') {
      let result = await pool.query(sql, [uid, type]);
      if (result.rows.length > 0) {
        return { status: 200, result: result.rows[0] }
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
    let sql = `
    select rmt_measure.id, measure_flag_title, measure_flag_text, rmt_device_type.description as device, 
    measure_type, instant, value
    from measure_flag
    inner join rmt_measure 
    on rmt_measure.id = measure_flag.rmt_measure_FK 
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
    where amd_acto_medico.doente = $1
    order by instant;
    `

    let result = await pool.query(sql, [uid]);
    if (result.rows.length > 0) {
      return { status: 200, result: result.rows }
    } else {
      return { status: 404 }
    }
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

