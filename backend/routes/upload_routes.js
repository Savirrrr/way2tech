
// routes/uploadRoutes.js
const express = require('express');
const router = express.Router();
const { 
  createUpload, 
  rejectUpload, 
  editUpload, 
  saveEditedUpload 
} = require('../controllers/uploadController');

router.post('/upload', createUpload);
router.delete('/reject/:tempId', rejectUpload);
router.get('/edit/:tempId', editUpload);
router.put('/edit/:tempId', saveEditedUpload);

module.exports = router;
