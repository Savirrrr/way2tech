const express = require('express');
const router = express.Router();
const { profileController } = require('../controllers/profileController');  
const { upload, handleUploadError } = require('../config/multer');

router.post('/upload-image', 
    upload.single('profileImage'),
    handleUploadError,
    profileController.uploadImage
);

router.get('/:email', profileController.getProfile);

module.exports = router;