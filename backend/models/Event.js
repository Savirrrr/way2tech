const mongoose = require('mongoose');

const eventSchema = new mongoose.Schema({
    title: String,
    description: String,
    startDate: Date,
    endDate: Date,
    registrationLink: String,
    image: String,
    email: { type: String, required: true },
    status: { type: String, default: 'Pending' }, 
});

const Event = mongoose.model('Event', eventSchema);

module.exports = Event;