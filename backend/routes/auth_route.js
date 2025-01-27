const express = require('express');
const { registerUser, forgotPassword , verifyForgotPasswordOtp, verifySignupOtp, loginUser} = require('../controllers/authController');
const connectDB = require('../utils/db');

const router = express.Router();

router.post('/register', async (req, res) => {
    const db = await connectDB();
    registerUser(db, req, res);
});
router.post('/login', async (req, res) => {
    const db = await connectDB();
    loginUser(db, req, res);
});

router.post('/forgot-password', async (req, res) => {
    const db = await connectDB();
    forgotPassword(db, req, res);
});

router.post('/requestpasswordreset', async (req, res) => {
    const db = await connectDB();
    requestPasswordReset(db, req, res);
});

router.post('/resetpassword', async (req, res) => {
    const db = await connectDB();
    resetPassword(db, req, res);
});

router.post('/verifySignupOtp', verifySignupOtp);

router.post('/verifyForgotPasswordOtp', verifyForgotPasswordOtp);


module.exports = router;