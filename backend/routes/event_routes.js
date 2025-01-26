const express = require('express');
const router = express.Router();
const { submitEvent, updateEventStatus } = require('../controllers/eventcontroller');

router.post('/submitEvent', submitEvent);
router.post('/admin/events/:id', updateEventStatus);

module.exports = router;