const getUserProfile = async (db, req, res) => {
    try {
        const user = await db.collection('users').findOne({ _id: req.user.id });
        if (!user) return res.status(404).json({ message: 'User not found' });
        res.status(200).json(user);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching profile', error });
    }
};

module.exports = { getUserProfile };