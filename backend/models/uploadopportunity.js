const mongoose = require('mongoose');

const uploadOpportunitySchema = new mongoose.Schema({
    title: { 
        type: String, 
        required: true 
    },
    caption: { 
        type: String 
    },
    email: { 
        type: String, 
        required: true 
    },
    userId: { 
        type: String, 
        required: true 
    },
    mediaUrl: { 
        type: String 
    },
    createdAt: { 
        type: Date, 
        default: Date.now 
    }
});

module.exports = mongoose.model('UploadOpportunity', uploadOpportunitySchema);
