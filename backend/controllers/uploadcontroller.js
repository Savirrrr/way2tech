// controllers/uploadController.js
const UploadOpportunity = require('../models/opportunity');
const multer = require('multer');
const path = require('path');

// Configure multer for file uploads
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname));
  }
});

const upload = multer({
  storage: storage,
  limits: { fileSize: 10 * 1024 * 1024 }, // 10MB limit
  fileFilter: function (req, file, cb) {
    const allowedTypes = /jpeg|jpg|png|mp4/;
    const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
    const mimetype = allowedTypes.test(file.mimetype);
    
    if (extname && mimetype) {
      return cb(null, true);
    }
    cb(new Error('Only jpeg, jpg, png, and mp4 files are allowed!'));
  }
}).single('media');

// Store temporary uploads with TTL
const tempUploads = new Map();
const TEMP_UPLOAD_TTL = 24 * 60 * 60 * 1000; // 24 hours

exports.createUpload = async (req, res) => {
  try {
    upload(req, res, async function(err) {
      if (err instanceof multer.MulterError) {
        return res.status(400).json({ error: 'File upload error: ' + err.message });
      } else if (err) {
        return res.status(400).json({ error: err.message });
      }

      const tempId = Date.now().toString();
      const { title, caption, email, userId } = req.body;

      const uploadData = {
        title,
        caption,
        email,
        userId,
        mediaUrl: req.file ? `/uploads/${req.file.filename}` : null
      };

      // Store in temporary storage
      tempUploads.set(tempId, {
        data: uploadData,
        timestamp: Date.now()
      });

      // Set timeout to clean up temporary upload
      setTimeout(() => {
        tempUploads.delete(tempId);
      }, TEMP_UPLOAD_TTL);

      res.status(200).json({ 
        message: 'Upload pending approval',
        tempId: tempId 
      });
    });
  } catch (error) {
    console.error('Upload error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

exports.rejectUpload = async (req, res) => {
  try {
    const { tempId } = req.params;
    
    if (!tempUploads.has(tempId)) {
      return res.status(404).json({ error: 'No pending upload found for this ID' });
    }

    // Delete the temporary upload
    tempUploads.delete(tempId);
    res.status(200).json({ message: 'Upload rejected successfully' });
  } catch (error) {
    console.error('Reject error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

exports.editUpload = async (req, res) => {
  try {
    const { tempId } = req.params;
    
    if (!tempUploads.has(tempId)) {
      return res.status(404).json({ error: 'No pending upload found for this ID' });
    }

    const uploadData = tempUploads.get(tempId).data;
    res.status(200).json({ data: uploadData });
  } catch (error) {
    console.error('Edit fetch error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

exports.saveEditedUpload = async (req, res) => {
  try {
    const { tempId } = req.params;
    const { title, caption, userId } = req.body;
    
    if (!tempUploads.has(tempId)) {
      return res.status(404).json({ error: 'No pending upload found for this ID' });
    }

    const uploadData = tempUploads.get(tempId).data;
    
    // Update with edited data
    const updatedData = {
      ...uploadData,
      title: title || uploadData.title,
      caption: caption || uploadData.caption,
      userId: userId || uploadData.userId
    };

    // Save to database
    const opportunity = new UploadOpportunity(updatedData);
    await opportunity.save();

    // Clear from temporary storage
    tempUploads.delete(tempId);

    res.status(200).json({ message: 'Upload saved successfully' });
  } catch (error) {
    console.error('Save error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};
