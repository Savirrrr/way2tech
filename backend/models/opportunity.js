const mongoose = require('mongoose');

const eventSchema = new mongoose.Schema({
    title: String,
    description: String,
    link: String,
    status: { type: String, default: 'Pending' }
});

module.exports = mongoose.model('Event', eventSchema);