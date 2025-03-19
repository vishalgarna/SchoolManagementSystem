const myconssql = require('mysql2');
require('dotenv').config();
const dbConnection =  require("./db")



// Step 2: Connect and Create Table
dbConnection.connect(
  err => {
  if (err) {
    console.error("Error connecting to database:", err);
    return;
  }
  console.log("Successfully connected to MySQL database!");

  // Step 3: Create 'schools' Table
  const createTableQuery = `
    CREATE TABLE IF NOT EXISTS schools (
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(255) NOT NULL,
      address VARCHAR(255) NOT NULL,
      latitude FLOAT NOT NULL,
      longitude FLOAT NOT NULL
    )
  `;

  dbConnection.query(createTableQuery, (err, result) => {
    if (err) {
      console.error("Error creating table:", err);
      return;
    }
    console.log("Table 'schools' created or already exists.");
    dbConnection.end();
  });
});
