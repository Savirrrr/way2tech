const Profile = require('../models/profile');

const profileController = {
  uploadImage: async (req, res) => {
    try {
      if (!req.file) {
        return res.status(400).json({ message: 'No file uploaded' });
      }
      
      const imageUrl = `/uploads/profiles/${req.file.filename}`;
      
      await Profile.findOneAndUpdate(
        { email: req.body.email },
        { profileImageUrl: imageUrl },
        { upsert: true }
      );
      
      res.json({ 
        message: 'Profile image uploaded successfully',
        imageUrl: imageUrl
      });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  getProfile: async (req, res) => {
    try {
      const profile = await Profile.findOne({ email: req.params.email });
      
      if (!profile) {
        return res.status(404).json({ message: 'Profile not found' });
      }
      
      res.json(profile);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
};

module.exports = profileController;