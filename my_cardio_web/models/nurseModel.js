var pool = require("./connection");

module.exports.getAllUsers = async function() {
    try {
        let sql ="Select * from nurses";
        let result = await pool.query(sql);
        let users = result.rows;
        return { status:200, result:users};
    } catch (err) {
        console.log(err);
        return { status:500, result: err};
    }
}

module.exports.login = async function(nome,password) {
    try {
        let sql ="Select * from nurses where nurse_name = $1 and nurse_password = $2";
        let result = await pool.query(sql,[nome,password]);
        if (result.rows.length > 0)
            return { status:200, result:result.rows[0]};
        else return { status:401, result: {msg: "Nome ou password errada"}};
    } catch (err) {
        console.log(err);
        return { status:500, result: err};
    }
}

module.exports.getUserById = async function(id) {
    try {
        let sql = "select * from nurses "+
        "where nurse_id = $1;";
        let result = await pool.query(sql,[id]);
        if (result.rows.length > 0)  
            return {status: 200, result: result.rows[0] };
        else return {status: 404, result: {msg: "Utilizador não encontrado"}};
    } catch(err) {
        console.log(err);
        return {status:500, result: err};
    }
} 

module.exports.getNurseInCharge = async function(id) {
    try {
        let sql = "select * from nurse_in_charge "+
        "inner join dnt_doente "+
        "on dnt_doente.codigo = nurse_in_charge.dnt_doente_codigo_FK "+
        "where nurse_id_FK = $1";
        let result = await pool.query(sql,[id]);
        if (result.rows.length > 0)  
            return {status: 200, result: result.rows };
        else return {status: 404, result: {msg: "Não está encarregado de nenhum paciente!"}};
    } catch(err) {
        console.log(err);
        return {status:500, result: err};
    }
} 

module.exports.insertFlag = async function(flag) {
    try {
        let sql ="insert into measure_flag (rmt_measure_FK,measure_flag_title,measure_flag_text) values ($1,$2,$3);";
        let result = await pool.query(sql,[flag.measure_id,flag.measure_title,flag.measure_text]);
        return { status:200, result:result.rows};
    } catch (err) {
        console.log(err);
        return { status:500, result: err};
    }
}

module.exports.editFlag = async function(data) {
    try {
        let sql ="update measure_flag "+
        "set measure_flag_title = $1, measure_flag_text = $2 where measure_flag_id = $3";
        let result = await pool.query(sql,[data.measure_flag_title,data.measure_flag_text,data.measure_flag_id]);
        return { status:200, result:result.rows[0]};
    } catch (err) {
        console.log(err);
        return { status:500, result: err};
    }
}

module.exports.removeFlag = async function(id) {
    try {
        let sql ="delete from measure_flag "+
        "where measure_flag_id = $1;";
        let result = await pool.query(sql,[id]);
        return { status:200, result:result.rows[0]};
    } catch (err) {
        console.log(err);
        return { status:500, result: err};
    }
}
