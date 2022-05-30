var pool = require("./connection");
const tf = require("@tensorflow/tfjs");

module.exports.insertChecklistItem = async function(checklist) {
    console.log(checklist)
    try {
        let sql ="insert into checklist (item_name, item_check, item_category, user_id_FK) values ($1, false, $2, $3);";
        let result = await pool.query(sql,[checklist.item_name,checklist.item_category,checklist.user_id_FK]);
        return { status:200, result:result.rows[0]};
    } catch (err) {
        console.log(err);
        return { status:500, result: err};
    }
}

module.exports.updateChecklistItemName = async function(id,data) {
    try {
        let sql ="update checklist "+
        "set item_name = $1, item_category = $2 where item_id = $3";
        let result = await pool.query(sql,[data.item_name,data.item_category,id]);
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

module.exports.insertModel = async function(data) {
    try {
        let model = undefined;
        model = await tf.loadLayersModel("https://raw.githubusercontent.com/hugomeduarte/testes/main/model.json");
        console.log("model loaded")

        input_xs = tf.tensor2d([
          [data.age, data.trestbps, data.chol, data.thalach, data.thal, data.sex, data.cp, data.fbs, data.restecg, data.exang, data.oldpeak, data.slope, data.ca]
        ]);

        let output = model.predict(input_xs);
        const outputData = output.dataSync();
        console.log(outputData);
        
        return { status:200, result:outputData};
    } catch (err) {
        console.log(err);
    }
}