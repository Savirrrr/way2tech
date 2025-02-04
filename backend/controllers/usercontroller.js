const { getDB } = require('../utils/db');

const getUserProfile = async (req, res) => {
    try {
        const { username } = req.body;
        if (!username) {
            return res.status(400).json({ message: 'Username is required' });
        }
        const { collection } = await getDB();
        const user = await collection.findOne({ username });
        res.status(200).json({ isTaken: !!user });
    } catch (error) {
        console.error('Error checking username:', error);
        res.status(500).json({ message: 'Internal error', error });
    }
};

const updateProfile=async (req,res)=>{
    const  {uname,updatedUname}=req.body;
    const { collection } = await getDB();
    const user = await collection.findOne({ username: uname });
    if (!user) {
        res.status(500).send('User not found');
    }
    try
    {
    const updatedUser = await collection.updateOne({ username: uname }, { $set: { username: updatedUname}});
    res.status(200).send('Username updated successfully');
    }
    catch(err)
    {
        console.error('error in updating username');
        res.status(500).send('couldnt update username');
    }

};

const getDetails= async (req,res)=>{
    const {email}=req.body;
    const { collection } = await getDB();
    const user=await collection.findOne({email:email});
    if(!user){
        res.status(500).send('User not found');
    }
    res.status(200).json({firstname:user.firstname,lastname:user.lastname,username:user.username,email:user.email})
}

module.exports = { getUserProfile ,updateProfile, getDetails};