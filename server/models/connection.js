var pg = require('pg');

const connectionString = "postgres://qxykafyzfkrnin:6520a72902ea212e84fc241cfcbdfea8f16b20038640c6cb4b5cd0b6385f7b7f@ec2-63-32-248-14.eu-west-1.compute.amazonaws.com:5432/d8lp3ms21a309k"
const Pool = pg.Pool
const pool = new Pool({
    connectionString,
    max: 10
})

module.exports = pool;
