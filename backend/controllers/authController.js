require('dotenv').config();
const { MongoClient } = require('mongodb');
const bcrypt = require('bcrypt');
const {sendEmail} = require('../utils/email');
const PasswordReset = require('../models/passwordreset');
const {getDB}=require('../utils/db');
const jwt = require('jsonwebtoken');
const saltRounds = 10;


const registerUser = async (req, res) => {
    // console.log(req.body);
    
    const { username, email, password, firstName, lastName} = req.body;

    try {
        const {otpCollection}=await getDB()
        
        await otpCollection.deleteMany({ email: email });
        const hashedPassword = await bcrypt.hash(password, saltRounds);
        // console.log(hashedPassword,"HASHED PASSWORD");

        const otp = Math.floor(100000 + Math.random() * 900000).toString();
        const expirationTime = new Date(Date.now() + 10 * 60 * 1000);

        const insertResult = await otpCollection.insertOne({
            fname:firstName,
            lname:lastName,
            username:username,
            email: email,
            password: hashedPassword,
            otp,
            expires_at: expirationTime,
            verified: false 
        },{writeConsern:{w:"majority"} });

        // console.log(`OTP Insertion Result: ${JSON.stringify(insertResult)}`);
        const insertedOtp = await otpCollection.findOne({ _id: insertResult.insertedId });
        // console.log('Inserted OTP Document:', insertedOtp);
        const emailBody = `Your OTP code is: ${otp}`;
        // console.log("calling email function");
        console.log("MAILING PARAMETERS",email,emailBody);
        
        try {
            console.log("Preparing to send email...");
            await sendEmail(email, 'Account Verification OTP', emailBody);
            console.log("Email function executed successfully.");
        } catch (err) {
            console.error("Error while calling sendEmail:", err.message);
            res.status(500).json({ message: 'Email sending failed.', error: err.message });
            return; 
        }
        res.status(200).json({message:'email sent'});
    } catch (error) {
        res.status(500).json({ message: 'Registration failed.', error });
    }
};

const loginUser = async (req, res) => {
    console.log(req.body);
    const {collection}=await getDB()
    const { emailOrUsername, password } = req.body;
    console.log(emailOrUsername,password);
    
    try {
        console.log("validating");
        let searchQuery;
        if (emailOrUsername.includes('@')) {
            searchQuery = { email: emailOrUsername };
        } else {
            searchQuery = { username: emailOrUsername };
        }
        console.log(searchQuery);
        if (!collection) {
            console.log("Collection is not initialized");
        }
        // console.log("Collection initialized:", collection);
        const user = await collection.findOne(searchQuery);
        if(!user)
        {
            console.log("INVALID");
            
        }
        console.log("USER",user);
        const isPasswordValid = await bcrypt.compare(password, password);
        if (!user || !isPasswordValid) {
            return res.status(401).json({ message: "Invalid credentials" });
        }
        console.log(`User logged in successfully: ${emailOrUsername}`);
        return res.status(200).send('User logged in successfully');
        } 
        catch (error) {
        console.log(error);
        
        res.status(500).json({ message: 'Login failed.', error });
    }
};


const forgotPassword = async (db, req, res) => {
    const { email } = req.body;

    try {
        const user = await db.collection('users').findOne({ email });
        if (!user) return res.status(404).json({ message: 'User not found.' });

        const reset = new PasswordReset(email);
        await db.collection('password_resets').insertOne(reset);

        const resetLink = `http://localhost:3000/reset-password?token=${reset.token}`;
        await sendEmail(email, 'Password Reset Request', `<p>Click <a href="${resetLink}">here</a> to reset your password.</p>`);

        res.status(200).json({ message: 'Password reset email sent.' });
    } catch (error) {
        res.status(500).json({ message: 'Error processing request.', error });
    }
};

const requestPasswordReset = async (db, req, res) => {
    const { email } = req.body;
    try {
        // Check if the email exists
        const user = await db.collection('users').findOne({ email });
        if (!user) return res.status(404).json({ message: 'Email not found' });

        // Create a reset token and store in PasswordReset collection
        const passwordReset = new PasswordReset(email);
        await db.collection('password_resets').insertOne(passwordReset);

        // Send email to user with reset link
        const resetLink = `http://localhost:${process.env.PORT}/resetpassword?token=${passwordReset.token}`;
        await sendEmail(email, 'Password Reset', `<a href="${resetLink}">Reset Password</a>`);

        res.status(200).json({ message: 'Password reset email sent' });
    } catch (error) {
        console.error('Error requesting password reset:', error);
        res.status(500).json({ message: 'Password reset failed', error });
    }
};

const resetPassword = async (db, req, res) => {
    const { token, newPassword } = req.body;

    try {
        const resetRequest = await db.collection('password_resets').findOne({ token });
        if (!resetRequest || resetRequest.expiresAt < new Date()) {
            return res.status(400).json({ message: 'Token expired or invalid' });
        }

        const user = await db.collection('users').findOne({ email: resetRequest.email });
        if (!user) return res.status(404).json({ message: 'User not found' });

        const hashedPassword = await hashPassword(newPassword);
        await db.collection('users').updateOne(
            { email: resetRequest.email },
            { $set: { password: hashedPassword } }
        );

        await db.collection('password_resets').deleteOne({ token });

        res.status(200).json({ message: 'Password reset successfully' });
    } catch (error) {
        console.error('Error resetting password:', error);
        res.status(500).json({ message: 'Password reset failed', error });
    }
};

const verifySignupOtp = async (req, res) => {
    const { email, username, otp } = req.body;
    try {
        const emailLower = email.toLowerCase();
        const otpRecord = await otpCollection.findOne({ email: emailLower, otp });

        if (!otpRecord) {
            return res.status(401).send('Invalid or expired OTP');
        }

        if (new Date() > otpRecord.expires_at) {
            return res.status(401).send('Invalid or expired OTP');
        }

        const userData = {
            username,
            firstname: otpRecord.fname,
            lastname: otpRecord.lname,
            email: otpRecord.email,
            password: otpRecord.password
        };

        await collection.insertOne(userData);
        await otpCollection.deleteOne({ email: emailLower, otp });

        res.status(200).send('User verified and added to database');
    } catch (err) {
        console.error(`Error verifying OTP: ${err}`);
        res.status(500).send('Internal server error');
    }
};

const verifyForgotPasswordOtp = async (req, res) => {
    const { email, otp } = req.body;
    const emailLower = email.toLowerCase();
    try {
        const otpRecord = await otpCollection.findOne({ email: emailLower, otp });

        if (!otpRecord || new Date() > otpRecord.expires_at) {
            return res.status(401).send('Invalid or expired OTP');
        }

        res.status(200).send('OTP verified, proceed to change password');
    } catch (err) {
        console.error(`Error verifying OTP: ${err}`);
        res.status(500).send('Internal server error');
    }
};

// module.exports = { registerUser, forgotPassword, loginUser, requestPasswordReset, resetPassword, verifyForgotPasswordOtp, verifySignupOtp };
module.exports = {
    registerUser,
    forgotPassword,
    verifyForgotPasswordOtp,
    verifySignupOtp,
    loginUser
  };