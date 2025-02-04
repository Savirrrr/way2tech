const express = require('express');
const { registerUser, forgotPassword , verifyForgotPasswordOtp, verifySignupOtp, loginUser, resetPassword} = require('../controllers/authController');
const {connectDB} = require('../utils/db');

const router = express.Router();

router.post('/register', async (req, res) => {
    registerUser(req, res);
});
router.post('/login', async (req, res) => {
    loginUser(req, res);
});

router.post('/forgot-password', async (req, res) => {
    forgotPassword( req, res);
});

router.post('/resetpassword', async (req, res) => {
    resetPassword(req, res);
});

router.post('/verifySignupOtp', verifySignupOtp);

router.post('/verifyForgotPasswordOtp', verifyForgotPasswordOtp);


module.exports = router;