const mongoose = require('mongoose');

const uploadOpportunitySchema = new mongoose.Schema({
    index: Number,
    title: String,
    description: String,
    link: String
});

module.exports = mongoose.model('UploadOpportunity', uploadOpportunitySchema);