var pool = require("./connection");

module.exports.getPatientMeasures = async function(id,type) {
    try {
        let sql = "select rmt_measure.id as MedidaId, amd_tipo_acto_medico.descricao as Acto_Medico, rmt_measure.instant as Instante, rmt_device_type.description as Dispositivo, "+
        "rmt_measure_type.description as Tipo_Medida, rmt_measure_type.unit as Unidades, rmt_measure.value as Valor "+
        "from rmt_measure "+
        "inner join amd_acto_medico "+
        "on rmt_measure.medical_act = amd_acto_medico.codigo "+
        "inner join amd_tipo_acto_medico "+
        "on amd_tipo_acto_medico.codigo = amd_acto_medico.tipo_acto_medico "+
        "inner join rmt_device_type_measure_type "+
        "on rmt_device_type_measure_type.id = rmt_measure.device_type_measure_type "+
        "inner join rmt_device_type "+
        "on rmt_device_type.id = rmt_device_type_measure_type.device_type "+
        "inner join rmt_measure_type "+
        "on rmt_measure_type.id = rmt_device_type_measure_type.measure_type ";

        if(type == "Heart Rate" || type == "Steps") {
            sql += 
            "where amd_acto_medico.doente = $1 and rmt_measure_type.description = $2 and rmt_device_type.description = 'Steel HR'"+
            "order by instante";
        }
        if(type == "Diastolic Blood Pressure" || type == "Systolic Blood Pressure") {
            sql += 
            "where amd_acto_medico.doente = $1 and rmt_measure_type.description = $2 and rmt_device_type.description = 'BPM+'"+
            "order by instante";
        }
        if(type == "Weight" || type == "Fat Ratio") {
            sql += 
            "where amd_acto_medico.doente = $1 and rmt_measure_type.description = $2 and rmt_device_type.description = 'Body+'"+
            "order by instante";
        }

        let result = await pool.query(sql,[id,type]);
        if (result.rows.length > 0)  
            return {status: 200, result: result.rows };
        else return {status: 204, result: {msg: "Este paciente não tem medições!"}};
    } catch(err) {
        console.log(err);
        return {status:500, result: err};
    }
} 

module.exports.getPatientMeasuresFlags = async function(id,type) {
    try {
        let sql = "select rmt_measure.id, measure_flag_id, measure_flag_title, measure_flag_text, instant, value "+ 
        "from measure_flag "+
        "inner join rmt_measure "+
        "on rmt_measure.id = measure_flag.rmt_measure_FK "+
        "inner join amd_acto_medico "+
        "on rmt_measure.medical_act = amd_acto_medico.codigo "+
        "inner join amd_tipo_acto_medico "+
        "on amd_tipo_acto_medico.codigo = amd_acto_medico.tipo_acto_medico "+
        "inner join rmt_device_type_measure_type "+
        "on rmt_device_type_measure_type.id = rmt_measure.device_type_measure_type "+
        "inner join rmt_device_type "+
        "on rmt_device_type.id = rmt_device_type_measure_type.device_type "+
        "inner join rmt_measure_type "+
        "on rmt_measure_type.id = rmt_device_type_measure_type.measure_type "+
        "where amd_acto_medico.doente = $1 and rmt_measure_type.description = $2 "+
        "order by instant";

        let result = await pool.query(sql,[id,type]);
        if (result.rows.length > 0)  
            return {status: 200, result: result.rows };
        else return {status: 204, result: {msg: "As medições do paciente não têm flags!"}};
    } catch(err) {
        console.log(err);
        return {status:500, result: err};
    }
} 