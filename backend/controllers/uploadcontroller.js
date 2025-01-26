const UploadOpportunity = require('../models/upploadopportunity'); 
const { sendEmail } = require('../utils/emailUtils');
let tempUploads = {}; 

exports.rejectUpload = (req, res) => {
    const tempId = req.params.tempId;

    if (tempUploads[tempId]) {
        delete tempUploads[tempId];
        res.send('Upload rejected');
    } else {
        res.status(404).send('No pending upload found for this ID');
    }
};

exports.editUpload = (req, res) => {
    const tempId = req.params.tempId;
    if (tempUploads[tempId]) {
        res.render('edit', { data: tempUploads[tempId], tempId });
    } else {
        res.status(404).send('No pending upload found for this ID');
    }
};

exports.saveEditedUpload = async (req, res) => {
    const tempId = req.params.tempId;
    const { text, userId } = req.body;
    if (tempUploads[tempId]) {
        tempUploads[tempId].text = text;
        tempUploads[tempId].userId = userId;

        try {
            await UploadOpportunity.insertOne(tempUploads[tempId]);  
            delete tempUploads[tempId];
            res.send('Data saved to the database successfully');
        } catch (err) {
            console.error(`Error saving data to database: ${err}`);
            res.status(500).send('Internal server error');
        }
    } else {
        res.status(404).send('No pending upload found for this ID');
    }
};