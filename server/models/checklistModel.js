var pool = require("./connection");

module.exports.getItemFromChecklist = async function(id) {
    try {
        let sql = "select item_id, item_name, item_check "+
        "from check_item "+
        "inner join checklist "+
        "on list_id_FK = list_id "+
        "where list_id = $1";
        let result = await pool.query(sql,[id]);
        if (result.rows.length > 0) 
            return { status:200, result:result.rows };
        else return {status: 404, result: {msg: "No items associated"}};
    } catch(err) {
        console.log(err);
        return {status:500, result: err};
    }
}

module.exports.insertChecklist = async function(checklist) {
    try {
        let sql ="insert into checklist (list_name, list_main, user_id_FK) values ($1, false, $2);";
        let result = await pool.query(sql,[checklist.list_name,checklist.user_id_FK]);
        return { status:200, result:result.rows[0]};
    } catch (err) {
        console.log(err);
        return { status:500, result: err};
    }
}

module.exports.removeChecklist = async function(id) {
    try {
        let sql ="delete from checklist "+
        "where list_id = $1;";
        let result = await pool.query(sql,[id]);
        return { status:200, result:result.rows[0]};
    } catch (err) {
        console.log(err);
        return { status:500, result: err};
    }
}

module.exports.updateChecklistName = async function(id,data) {
    try {
        let sql ="update checklist "+
        "set list_name = $1 where list_id = $2";
        let result = await pool.query(sql,[data.list_name,id]);
        return { status:200, result:result.rows[0]};
    } catch (err) {
        console.log(err);
        return { status:500, result: err};
    }
}

module.exports.updateChecklistMain = async function(id) {
    try {
        let sql ="select list_id from checklist where list_main = true";
        let result = await pool.query(sql);
        console.log(result.rows[0].list_id);

        let sql2 ="update checklist "+
        "set list_main = false where list_id = $1";
        let result2 = await pool.query(sql2,[result.rows[0].list_id]);

        let sql3 ="update checklist "+
        "set list_main = true where list_id = $1";
        let result3 = await pool.query(sql3,[id]);

        return { status:200, result:result.rows[0]};
    } catch (err) {
        console.log(err);
        return { status:500, result: err};
    }
}
