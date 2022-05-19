var pg = require('pg');

const connectionString = "postgres://postgres:!5!F8w%MKn9javFwBZA3@localhost:5432/MyCardio"
const Pool = pg.Pool
const pool = new Pool({
    connectionString,
    max: 10,
    ssl: {
        require: true, 
        rejectUnauthorized: false
    }
})

module.exports = pool;
