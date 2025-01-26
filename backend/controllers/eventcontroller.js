const Event = require('../models/Event'); 
const nodemailer = require('nodemailer');

const submitEvent = async (req, res) => {
    try {
        const newEvent = new Event(req.body);
        await newEvent.save();
        res.send('Event submitted successfully!');
    } catch (error) {
        console.error(error);
        res.status(500).send('Error submitting event.');
    }
};

const updateEventStatus = async (req, res) => {
    try {
        const { id } = req.params;
        const { status } = req.body;
        const event = await Event.findByIdAndUpdate(id, { status }, { new: true });

        const mailOptions = {
            from: 'balasubramanyamchilukala@gmail.com',
            to: 'baluchilukala900@gmail.com',
            subject: `Event ${status}`,
            text: `Dear User,\n\nYour event "${event.title}" has been ${status.toLowerCase()}.\n\nThank you for using our platform!`,
        };

        await transporter.sendMail(mailOptions);

        res.send(`Event has been ${status.toLowerCase()}! Email notification sent.`);
    } catch (error) {
        console.error(error);
        res.status(500).send('Error updating event status or sending email.');
    }
};

module.exports={submitEvent,updateEventStatus};