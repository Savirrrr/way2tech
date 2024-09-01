const express = require('express');
const bcrypt = require('bcrypt');
const crypto = require('crypto');
const nodemailer = require('nodemailer');
const { MongoClient } = require('mongodb');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

const client = new MongoClient("mongodb+srv://peecharasavir:DLv37jsi391FY9MR@cluster0.jv90ftt.mongodb.net/?retryWrites=true&w=majority");

let collection;
let otpCollection;

async function connectDB() {
    try {
        await client.connect();
        collection = client.db("user_info").collection("users");
        otpCollection = client.db("user_info").collection("otp_tokens");
        console.log("Connected to MongoDB!");
    } catch (err) {
        console.error(err);
        process.exit(1);
    }
}

// Store user details temporarily with OTP
app.post('/signup', async (req, res) => {
    const user = req.body;
    user.email = user.email.toLowerCase();

    try {
        // Hash the password
        const hashedPassword = await bcrypt.hash(user.password, 10);

        // Delete any existing OTPs for this email
        await otpCollection.deleteMany({ email: user.email });

        // Generate OTP
        const otp = Math.floor(100000 + Math.random() * 900000).toString();
        const expirationTime = new Date(Date.now() + 10 * 60 * 1000); // 10 minutes

        // Log the OTP and expiration time
        console.log(`Generated OTP: ${otp}, Expiration Time: ${expirationTime}`);

        // Insert the user details and OTP into a temporary collection
        const insertResult = await otpCollection.insertOne({
            email: user.email,
            password: hashedPassword, // Store the hashed password temporarily
            otp,
            expires_at: expirationTime,
            verified: false // Initially set to false
        });

        // Log the insertion result
        console.log(`OTP Insertion Result: ${JSON.stringify(insertResult)}`);

        if (insertResult.insertedCount === 0) {
            console.error('Failed to insert OTP into the database');
            res.status(500).send('Failed to generate OTP. Please try again.');
            return;
        }

        // Send OTP via email
        const emailBody = `Your OTP code is: ${otp}`;
        await sendEmail(user.email, 'Account Verification OTP', emailBody);
        console.log(`OTP sent to: ${user.email}`);

        res.status(200).send('User signed up successfully. Please verify your email.');
    } catch (err) {
        console.error(`Error during signup: ${err}`);
        res.status(500).send('Internal server error');
    }
});


// Verify OTP and move user details to the main collection
app.post('/verifySignupOtp', async (req, res) => {
    const { email, otp } = req.body;

    try {
        const emailLower = email.toLowerCase();

        // Find the OTP record
        const otpRecord = await otpCollection.findOne({ email: emailLower, otp });

        if (!otpRecord) {
            console.log('OTP record not found or mismatch');
            res.status(401).send('Invalid or expired OTP');
            return;
        }

        if (new Date() > otpRecord.expires_at) {
            console.log('OTP expired');
            res.status(401).send('Invalid or expired OTP');
            return;
        }

        // OTP is valid, insert into the main users collection
        await collection.insertOne({
            email: otpRecord.email,
            password: otpRecord.password // Hashed password
        });

        // Mark the OTP record as verified (optional) or delete it
        await otpCollection.deleteOne({ email: emailLower, otp });

        console.log(`User verified and added to database: ${emailLower}`);
        res.status(200).send('User verified and added to database');
    } catch (err) {
        console.error(`Error verifying OTP: ${err}`);
        res.status(500).send('Internal server error');
    }
});

async function sendEmail(to, subject, body) {
    const from = 'mailer.learnx@gmail.com';
    const password = 'glfd kcgf dhpx hiwk';

    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: from,
            pass: password
        }
    });

    const mailOptions = {
        from: from,
        to: to,
        subject: subject,
        text: body
    };

    try {
        await transporter.sendMail(mailOptions);
        console.log(`Email sent successfully to ${to}`);
    } catch (err) {
        console.error(`Error sending email to ${to}: ${err}`);
    }
}

app.post('/login', async (req, res) => {
    const { email, password } = req.body;
    const emailLower = email.toLowerCase(); // Ensure email is in lowercase

    console.log(`Login attempt with email: ${emailLower}`);

    try {
        // Retrieve the user from the database
        const storedUser = await collection.findOne({ email: emailLower });

        if (!storedUser) {
            console.log(`User not found for email: ${emailLower}`);
            res.status(401).send('Incorrect username/password');
            return;
        }

        console.log(`User found: ${storedUser.email}`);

        // Compare the provided password with the stored hashed password
        const isMatch = await bcrypt.compare(password, storedUser.password);
        if (!isMatch) {
            console.log(`Incorrect password for user: ${emailLower}`);
            res.status(401).send('Incorrect username/password');
            return;
        }

        console.log(`User logged in successfully: ${emailLower}`);
        res.status(200).send('User logged in successfully');
    } catch (err) {
        console.error(`Error during login: ${err}`);
        res.status(500).send('Internal server error');
    }
});
app.post('/forgotpwd', async (req, res) => {
    const { email } = req.body;

    try {
        // Delete any existing OTP for this email
        await otpCollection.deleteMany({ email: email.toLowerCase() });

        // Generate a new OTP
        const otp = Math.floor(100000 + Math.random() * 900000).toString();
        const expirationTime = new Date(Date.now() + 10 * 60 * 1000); // 10 minutes

        await otpCollection.insertOne({ email: email.toLowerCase(), otp, expires_at: expirationTime });

        const emailBody = `Your OTP code is: ${otp}`;

        await sendEmail(email, 'Password Reset OTP', emailBody);
        console.log(`OTP sent to: ${email}`);

        res.status(200).send('OTP sent successfully');
    } catch (err) {
        console.error(`Error processing forgot password: ${err}`);
        res.status(500).send('Internal server error');
    }
});

app.post('/verifyotp', async (req, res) => {
    const { email, otp } = req.body;

    try {
        const otpRecord = await otpCollection.findOne({ email: email.toLowerCase(), otp });

        if (!otpRecord || new Date() > otpRecord.expires_at) {
            res.status(401).send('Invalid or expired OTP');
            return;
        }

        res.status(200).send('OTP verified');
    } catch (err) {
        console.error(`Error verifying OTP: ${err}`);
        res.status(500).send('Internal server error');
    }
});

app.post('/resetpassword', async (req, res) => {
    const { email, newPassword } = req.body;
    const emailLower = email.toLowerCase();

    try {
        // Hash the new password
        const hashedPassword = await bcrypt.hash(newPassword, 10);

        // Update the user's password in the database
        const result = await collection.updateOne(
            { email: emailLower },
            { $set: { password: hashedPassword } }
        );

        if (result.modifiedCount === 1) {
            res.status(200).send('Password updated successfully');
        } else {
            res.status(400).send('Failed to update password');
        }
    } catch (err) {
        console.error(`Error resetting password: ${err}`);
        res.status(500).send('Internal server error');
    }
});

app.post('/verifyForgotPasswordOtp', async (req, res) => {
    const { email, otp } = req.body;
    const emailLower = email.toLowerCase(); // Ensure consistent email case

    try {
        const otpRecord = await otpCollection.findOne({ email: emailLower, otp });

        // Debugging logs
        console.log(`OTP record: ${JSON.stringify(otpRecord)}`);
        console.log(`Current Time: ${new Date()}`);
        console.log(`OTP Expiration Time: ${otpRecord ? otpRecord.expires_at : 'No OTP Record Found'}`);

        if (!otpRecord) {
            console.log('OTP record not found or mismatch');
            return res.status(401).send('Invalid or expired OTP');
        }

        if (new Date() > otpRecord.expires_at) {
            console.log('OTP expired');
            return res.status(401).send('Invalid or expired OTP');
        }

        // OTP is valid, allow user to reset their password
        res.status(200).send('OTP verified, proceed to change password');
    } catch (err) {
        console.error(`Error verifying OTP: ${err}`);
        res.status(500).send('Internal server error');
    }
});


async function startServer() {
    await connectDB();

    const PORT = 3000;
    app.listen(PORT, () => {
        console.log(`Server is running on port ${PORT}...`);
    });
}

startServer();
