const express = require('express');
const { uploadMedia, getMedia } = require('../controllers/mediacontroller');
const {connectDB} = require('../utils/db');
const fileUpload = require('express-fileupload');

const router = express.Router();

router.use(fileUpload());

router.post('/upload', async (req, res) => {
    const db = await connectDB();
    uploadMedia(db, req, res);
});

router.get('/media/:id', async (req, res) => {
    const db = await connectDB();
    getMedia(db, req, res);
});

module.exports = router;