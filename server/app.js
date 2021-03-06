var express = require('express');
var cors = require('cors');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

var userRouter = require('./routes/usersRoutes');
var checklistRouter = require('./routes/checklistRoutes');

var app = express();

app.use(cors());
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/api/users', userRouter);
app.use('/api/checklist', checklistRouter);

app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    next();
});

module.exports = app;

