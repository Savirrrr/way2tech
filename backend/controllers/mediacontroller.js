const Media = require('../models/Media');
const { get } = require('../routes/auth_route');

const uploadMedia = async (db, req, res) => {
    const { title, caption } = req.body;
    const file = req.file;

    if (!file) return res.status(400).json({ message: 'No file uploaded.' });

    try {
        const media = new Media(title, caption, file);
        await db.collection('media').insertOne(media);
        res.status(201).json({ message: 'Media uploaded successfully.', id: media._id });
    } catch (error) {
        res.status(500).json({ message: 'Upload failed.', error });
    }
};

const getMedia = async (db, req, res) => {
    try {
        const mediaId = req.params.id;
        const media = await db.collection('media').findOne({ _id: new ObjectId(mediaId) });
        if (!media) return res.status(404).json({ message: 'Media not found' });
        
        res.status(200).json(media);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching media', error });
    }
};

module.exports = { uploadMedia,getMedia};