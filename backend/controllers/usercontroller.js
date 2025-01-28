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

module.exports = { getUserProfile };