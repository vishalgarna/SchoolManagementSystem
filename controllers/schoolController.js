const db = require('../db');

// Add School API
exports.addSchool = async (req, res) => {
  console.log("addig not ");
  
  try {
    const { name, address, latitude, longitude } = req.body;
    if (!name || !address || !latitude || !longitude) {
      return res.status(400).json({ error: "All fields are required" });
    }

    await db.query('INSERT INTO schools (name, address, latitude, longitude) VALUES (?, ?, ?, ?)', 
      [name, address, latitude, longitude]);

    res.status(201).json({ message: "School added successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// List Schools API (Sorted by Distance)
exports.listSchools = async (req, res) => {
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
};
