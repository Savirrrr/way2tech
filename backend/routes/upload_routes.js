const express = require('express');
const router = express.Router();
const { rejectUpload, editUpload, saveEditedUpload } = require('../controllers/uploadcontroller');

router.get('/reject/:tempId', rejectUpload);
router.get('/edit/:tempId', editUpload);
router.post('/edit/:tempId', saveEditedUpload);

module.exports = router;