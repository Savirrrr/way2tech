const express = require('express');
const bcrypt = require('bcrypt');
const crypto = require('crypto');
const nodemailer = require('nodemailer');
const { MongoClient } = require('mongodb');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

const client = new MongoClient("mongodb+srv://peecharasavir:DLv37jsi391FY9MR@cluster0.jv90ftt.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");

let collection;
let otpCollection;

async function connectDB() {
    try {
        await client.connect();
        collection = client.db("user_info").collection("users");
        otpCollection = client.db("user_info").collection("otps");
        console.log("Connected to MongoDB!");
    } catch (err) {
        console.error(err);
        process.exit(1);
    }
}

app.post('/signup', async (req, res) => {
    if (req.method === 'POST') {
        const user = req.body;
        user.email = user.email.toLowerCase();

        try {
            const hashedPassword = await bcrypt.hash(user.password, 10);
            user.password = hashedPassword;

            await collection.insertOne(user);
            console.log(`User signed up successfully: ${user.email}`);
            res.status(200).send('User signed up successfully');
        } catch (err) {
            console.error(`Error inserting user into database: ${err}`);
            res.status(500).send(err.message);
        }
    } else {
        console.log(`Invalid request method: ${req.method}`);
        res.status(405).send('Invalid request method');
    }
});

app.post('/login', async (req, res) => {
    if (req.method === 'POST') {
        const user = req.body;
        user.email = user.email.toLowerCase();

        console.log(`Logging in with email: ${user.email}`);

        try {
            const storedUser = await collection.findOne({ email: user.email });

            if (!storedUser) {
                console.log(`User not found in database: ${user.email}`);
                res.status(401).send('User not found');
                return;
            }

            console.log(`User found: ${storedUser.email}`);

            const isMatch = await bcrypt.compare(user.password, storedUser.password);
            if (!isMatch) {
                console.log(`Invalid password for user: ${user.email}`);
                res.status(401).send('Invalid password');
                return;
            }

            console.log(`User logged in successfully: ${user.email}`);
            res.status(200).send('User logged in successfully');
        } catch (err) {
            console.error(`Error finding user in database: ${err}`);
            res.status(500).send(err.message);
        }
    } else {
        console.log(`Invalid request method: ${req.method}`);
        res.status(405).send('Invalid request method');
    }
});

function generateToken() {
    return crypto.randomBytes(32).toString('hex');
}

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
    const { email, otp, newPassword } = req.body;

    try {
        const otpRecord = await otpCollection.findOne({ email: email.toLowerCase(), otp });

        if (!otpRecord || new Date() > otpRecord.expires_at) {
            res.status(401).send('Invalid or expired OTP');
            return;
        }

        const hashedPassword = await bcrypt.hash(newPassword, 10);
        await collection.updateOne({ email: email.toLowerCase() }, { $set: { password: hashedPassword } });

        await otpCollection.deleteOne({ email: email.toLowerCase(), otp });

        console.log(`Password updated for user: ${email}`);
        res.status(200).send('Password updated successfully');
    } catch (err) {
        console.error(`Error resetting password: ${err}`);
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
