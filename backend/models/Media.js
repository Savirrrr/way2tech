const { ObjectId } = require('mongodb');

class Media {
    constructor(title, caption, file) {
        this._id = new ObjectId();
        this.title = title;
        this.caption = caption;
        this.file = {
            data: file.buffer,
            contentType: file.mimetype,
            originalName: file.originalname,
        };
        this.uploadedAt = new Date();
    }
}

module.exports = Media;