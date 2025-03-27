^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530  1) const express = require('express');
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530  2) require('dotenv').config();
74362de9 (VishalSaini       2025-03-19 14:03:46 +0530  3) require("./db")
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530  4) const app = express();
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530  5) app.use(express.json());
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530  6) 
f9e26998 (VishalSaini       2025-03-27 14:02:02 +0530  7) console.log("addinc some more content ");
00000000 (Not Committed Yet 2025-03-27 14:17:45 +0530  8) console.log("addin more som ertra for testing ");
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530  9) 
74362de9 (VishalSaini       2025-03-19 14:03:46 +0530 10) 
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 11) const mysql = require('mysql2/promise');
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 12) const db = mysql.createPool({
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 13)   host: process.env.DB_HOST,
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 14)   user: process.env.DB_USER,
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 15)   password: process.env.DB_PASSWORD,
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 16)   database: process.env.DB_NAME,
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 17) });
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 18) 
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 19) 
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 20) app.get("/listSchools", async(req, res)=>{
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 21)   console.log("what is ");
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 22)   
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 23)   try {
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 24)     const { latitude, longitude } = req.query;
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 25)     if (!latitude || !longitude) {
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 26)       return res.status(400).json({ error: "Latitude and Longitude are required" });
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 27)     }
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 28) 
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 29)     const [schools] = await db.query(`
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 30)       SELECT id, name, address, latitude, longitude, 
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 31)       ( 6371 * ACOS(COS(RADIANS(?)) * COS(RADIANS(latitude)) * 
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 32)       COS(RADIANS(longitude) - RADIANS(?)) + SIN(RADIANS(?)) * SIN(RADIANS(latitude)))) 
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 33)       AS distance FROM schools ORDER BY distance ASC`, [latitude, longitude, latitude]);
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 34) 
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 35)     res.status(200).json({ schools });
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 36)   } catch (err) {
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 37)     res.status(500).json({ error: err.message });
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 38)   }
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 39) })
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 40) 
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 41) 
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 42) app.post("/addSchool", async (req, res) => {
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 43)   console.log("Adding new school...");
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 44) 
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 45)   try {
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 46)     const { name, address, latitude, longitude } = req.body;
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 47) 
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 48)     // Check if all fields are provided
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 49)     if (!name || !address || !latitude || !longitude) {
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 50)       return res.status(400).json({ error: "All fields are required" });
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 51)     }
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 52) 
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 53)     // Insert into database
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 54)     const query = `
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 55)       INSERT INTO schools (name, address, latitude, longitude) 
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 56)       VALUES (?, ?, ?, ?)
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 57)     `;
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 58)     await db.query(query, [name, address, latitude, longitude]);
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 59) 
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 60)     // Success response
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 61)     res.status(201).json({ message: "School added successfully" });
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 62)   } catch (err) {
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 63)     console.error("Database error:", err.message);
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 64)     res.status(500).json({ error: "An internal server error occurred." });
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 65)   }
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 66) });
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 67) 
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 68) 
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 69) const PORT = process.env.PORT || 5000;
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 70) app.listen(PORT, () => {
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 71)   console.log(`Server is running on port ${PORT}`);
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 72)  
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 73) });
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 74) 
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 75) 
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 76) 
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 77) 
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 78) 
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 79) 
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 80) 
^e5ef029 (VishalSaini       2025-03-19 13:51:47 +0530 81) 
