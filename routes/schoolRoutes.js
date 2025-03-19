const express = require('express');
const { addSchool, listSchools } = require('../controllers/schoolController');

const router = express.Router();

router.post('api/addSchool', addSchool);
router.get('api/listSchools', listSchools);

module.exports = router;
