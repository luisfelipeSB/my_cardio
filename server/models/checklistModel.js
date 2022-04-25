var pool = require("./connection");

module.exports.insertChecklistItem = async function(checklist) {
    try {
        let sql ="insert into checklist (item_name, item_check, user_id_FK) values ($1, false, $2);";
        let result = await pool.query(sql,[checklist.item_name,checklist.user_id_FK]);
        return { status:200, result:result.rows[0]};
    } catch (err) {
        console.log(err);
        return { status:500, result: err};
    }
}

module.exports.updateChecklistItemName = async function(id,data) {
    try {
        let sql ="update checklist "+
        "set item_name = $1 where item_id = $2";
        let result = await pool.query(sql,[data.item_name,id]);
        return { status:200, result:result.rows[0]};
    } catch (err) {
        console.log(err);
        return { status:500, result: err};
    }
}

module.exports.removeChecklistItem = async function(id) {
    try {
        let sql ="delete from checklist "+
        "where item_id = $1;";
        let result = await pool.query(sql,[id]);
        return { status:200, result:result.rows[0]};
    } catch (err) {
        console.log(err);
        return { status:500, result: err};
    }
}

module.exports.updateChecklistItemCheck = async function(id) {
    try {
        let sql ="select item_check from checklist where item_id = $1";
        let result = await pool.query(sql,[id]);
        //console.log(result.rows[0].item_check);

        let sql2;
        if(result.rows[0].item_check == false) {
            sql2 ="update checklist "+
            "set item_check = true where item_id = $1";
            let result2 = await pool.query(sql2,[id]);
        } else {
            sql2 ="update checklist "+
            "set item_check = false where item_id = $1";
            let result3 = await pool.query(sql2,[id]);
        }

        return { status:200, result:result.rows[0]};
    } catch (err) {
        console.log(err);
        return { status:500, result: err};
    }
}