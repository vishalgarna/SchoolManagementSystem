const mysql = require('mysql2');
require('dotenv').config();

const connection = mysql.createConnection("mysql://sql12768479:pmEibmpHeH@sql12.freesqldatabase.com:3306/sql12768479");

connection.connect(err => {
  if (err) {
    console.error("Database connection failed: " + err.stack);
    return;
  }
  console.log("Connected to MySQL Database!");
});



module.exports = connection;
