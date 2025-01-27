const mongoose = require('mongoose');

const eventSchema = new mongoose.Schema({
    title: String,
    description: String,
    link: String,
    status: { type: String, default: 'Pending' }
});

const Event = mongoose.models.Event || mongoose.model('Event', opportunitySchema);

module.exports = Event;