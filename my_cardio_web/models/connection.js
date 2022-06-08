var pg = require('pg');

const connectionString = "postgres://postgres:hugoportugal2001@localhost:5432/MyCardio+HSM"
const Pool = pg.Pool
const pool = new Pool({
    connectionString,
    max: 10
})

module.exports = pool;