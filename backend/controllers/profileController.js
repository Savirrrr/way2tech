const { getDB } = require('../utils/db');

const profileOperations = {
  async findProfile(email) {
    try {
      const { profileCollection } = await getDB();
      const profile = await profileCollection.findOne({ email });
      
      if (profile) {
        profile.createdAt = profile.createdAt || new Date();
        profile.updatedAt = new Date();
      }
      
      return profile;
    } catch (error) {
      console.error('Error finding profile:', error);
      throw error;
    }
  },

  async updateProfile(email, profileData) {
    try {
      const { profileCollection } = await getDB();
      const result = await profileCollection.findOneAndUpdate(
        { email },
        { 
          $set: {
            ...profileData,
            updatedAt: new Date()
          },
          $setOnInsert: {
            createdAt: new Date()
          }
        },
        { 
          upsert: true, 
          returnDocument: 'after'
        }
      );
      return result;
    } catch (error) {
      console.error('Error updating profile:', error);
      throw error;
    }
  }
};

const profileController = {
  uploadImage: async (req, res) => {
    try {
      console.log("Processing image upload request");
      
      if (!req.file) {
        console.log("No file received in request");
        return res.status(400).json({ message: 'No file uploaded' });
      }

      const allowedTypes = ['image/jpeg', 'image/png', 'image/jpg'];
      if (!allowedTypes.includes(req.file.mimetype)) {
        return res.status(400).json({ message: 'Invalid file type' });
      }

      if (!req.body.email) {
        return res.status(400).json({ message: 'Email is required' });
      }
      
      const imageUrl = `/uploads/profiles/${req.file.filename}`;
      console.log(`Generated image URL: ${imageUrl}`);

      // Generate full URL for the image including host
      const fullImageUrl = `${req.protocol}://${req.get('host')}${imageUrl}`;
      
      const updatedProfile = await profileOperations.updateProfile(
        req.body.email,
        { 
          profileImageUrl: imageUrl,
          fullImageUrl: fullImageUrl
        }
      );

      console.log('File upload successful:', {
        profile: updatedProfile,
        file: {
          mimetype: req.file.mimetype,
          originalname: req.file.originalname,
          filename: req.file.filename,
          size: req.file.size,
          url: fullImageUrl
        }
      });

      res.json({ 
        message: 'Profile image uploaded successfully',
        imageUrl: imageUrl,
        fullImageUrl: fullImageUrl,
        profile: updatedProfile
      });
    } catch (error) {
      console.error('Error in uploadImage:', error);
      res.status(500).json({ message: 'Error uploading image: ' + error.message });
    }
  },

  getProfile: async (req, res) => {
    try {
      const { email } = req.params;
      console.log(`Fetching profile for email: ${email}`);
      
      if (!email) {
        return res.status(400).json({ message: 'Email is required' });
      }
      
      const profile = await profileOperations.findProfile(email);
      
      if (!profile) {
        console.log(`Profile not found for email: ${email}`);
        return res.status(404).json({ message: 'Profile not found' });
      }

      // Add full URL if it doesn't exist
      if (profile.profileImageUrl && !profile.fullImageUrl) {
        profile.fullImageUrl = `${req.protocol}://${req.get('host')}${profile.profileImageUrl}`;
      }
      
      res.json(profile);
    } catch (error) {
      console.error('Error in getProfile:', error);
      res.status(500).json({ message: 'Error fetching profile: ' + error.message });
    }
  }
};

module.exports = { profileController, profileOperations };