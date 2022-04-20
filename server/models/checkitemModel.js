var pool = require("./connection");

module.exports.insertChecklistItem = async function(check_item) {
    try {
        let sql ="insert into check_item (item_name, item_check, list_id_FK) values ($1, 0, $2);";
        let result = await pool.query(sql,[check_item.item_name,check_item.list_id_FK]);
        return { status:200, result:result.rows[0]};
    } catch (err) {
        console.log(err);
        return { status:500, result: err};
    }
}

module.exports.removeItem = async function(id) {
    try {
        let sql ="delete from check_item "+
        "where item_id = $1;";
        let result = await pool.query(sql,[id]);
        return { status:200, result:result.rows[0]};
    } catch (err) {
        console.log(err);
        return { status:500, result: err};
    }
}

module.exports.updateCheckitemName = async function(id,data) {
    try {
        let sql ="update check_item "+
        "set item_name = $1 where item_id = $2";
        let result = await pool.query(sql,[data.item_name,id]);
        return { status:200, result:result.rows[0]};
    } catch (err) {
        console.log(err);
        return { status:500, result: err};
    }
}

module.exports.updateCheckitemCheck = async function(id) {
    try {
        let sql ="select item_check from check_item where item_id = $1";
        let result = await pool.query(sql,[id]);
        console.log(result.rows[0].item_check);

        let sql2;
        if(result.rows[0].item_check == 0) {
            sql2 ="update check_item "+
            "set item_check = 1 where item_id = $1";
            let result2 = await pool.query(sql2,[id]);
        } else {
            sql2 ="update check_item "+
            "set item_check = 0 where item_id = $1";
            let result3 = await pool.query(sql2,[id]);
        }

        return { status:200, result:result.rows[0]};
    } catch (err) {
        console.log(err);
        return { status:500, result: err};
    }
}