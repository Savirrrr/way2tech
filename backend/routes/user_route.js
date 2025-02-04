const express = require('express');
const { getUserProfile, getDetails, updateProfile  } = require('../controllers/usercontroller');
const {connectDB} = require('../utils/db');

const router = express.Router();

router.post('/profile', async (req, res) => {
    getUserProfile(req, res);
});

router.post('/getDetails',async(req,res)=>{
    getDetails(req,res);
})

router.post('/updateDetails',async(req,res)=>{
    updateProfile(req,res);
})


module.exports = router;