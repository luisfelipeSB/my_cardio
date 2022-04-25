var pg = require('pg');

const connectionString = "postgres://postgres:password@localhost:5432/MyCardio"
const Pool = pg.Pool
const pool = new Pool({
    connectionString,
    max: 10
})

module.exports = pool;