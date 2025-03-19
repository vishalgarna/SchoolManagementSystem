const express = require('express');
require('dotenv').config();
require("./db")
const app = express();
app.use(express.json());



const mysql = require('mysql2/promise');
const db = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});


app.get("/listSchools", async(req, res)=>{
  console.log("what is ");
  
  try {
    const { latitude, longitude } = req.query;
    if (!latitude || !longitude) {
      return res.status(400).json({ error: "Latitude and Longitude are required" });
    }

    const [schools] = await db.query(`
      SELECT id, name, address, latitude, longitude, 
      ( 6371 * ACOS(COS(RADIANS(?)) * COS(RADIANS(latitude)) * 
      COS(RADIANS(longitude) - RADIANS(?)) + SIN(RADIANS(?)) * SIN(RADIANS(latitude)))) 
      AS distance FROM schools ORDER BY distance ASC`, [latitude, longitude, latitude]);

    res.status(200).json({ schools });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
})


app.post("/addSchool", async (req, res) => {
  console.log("Adding new school...");

  try {
    const { name, address, latitude, longitude } = req.body;

    // Check if all fields are provided
    if (!name || !address || !latitude || !longitude) {
      return res.status(400).json({ error: "All fields are required" });
    }

    // Insert into database
    const query = `
      INSERT INTO schools (name, address, latitude, longitude) 
      VALUES (?, ?, ?, ?)
    `;
    await db.query(query, [name, address, latitude, longitude]);

    // Success response
    res.status(201).json({ message: "School added successfully" });
  } catch (err) {
    console.error("Database error:", err.message);
    res.status(500).json({ error: "An internal server error occurred." });
  }
});


const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
 
});








