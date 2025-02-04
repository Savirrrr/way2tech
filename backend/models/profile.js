const mongoose = require('mongoose');

const profileSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
    unique: true
  },
  fullName: {
    type: String,
    required: true
  },
  username: {
    type: String,
    required: true,
    unique: true
  },
  profileImageUrl: {
    type: String
  }
}, {
  timestamps: true
});

module.exports = mongoose.model('Profile', profileSchema);
