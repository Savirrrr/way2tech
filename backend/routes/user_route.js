const express = require('express');
const { getUserProfile } = require('../controllers/usercontroller');
const connectDB = require('../utils/db');

const router = express.Router();

router.get('/profile', async (req, res) => {
    const db = await connectDB();
    getUserProfile(db, req, res);
});
// router.get('/reject/:tempId', rejectUpload);

// router.get('/edit/:tempId', editUpload);

// router.post('/edit/:tempId', saveEditedUpload);

module.exports = router;