const mongoose = require('mongoose');

const otpSchema = new mongoose.Schema({
    email: String,
    otp: String,
    expires_at: Date,
    fname: String,
    lname: String,
    password: String
});

module.exports = mongoose.model('Otp', otpSchema);