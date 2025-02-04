require('dotenv').config();
const express = require('express');
const cors = require('cors');
const authRoutes = require('./routes/auth_route');
const mediaRoutes = require('./routes/media_route');
const eventRoutes = require('./routes/event_routes');
const uploadRoutes = require('./routes/upload_routes');
const userRoutes = require('./routes/user_route');
const { initializeDB } = require('./utils/db');
const profileRoutes = require('./routes/profile_routes');

const app = express();
app.use(express.json());
app.use(cors());
app.use(express.urlencoded({ extended: true }));

async function startServer() {
    try {
        await initializeDB();
        console.log("MongoDB connection established");

        app.use('/api/auth', authRoutes);
        app.use('/api/user', userRoutes);
        app.use('/api/media', mediaRoutes);
        app.use('/api/event', eventRoutes);
        app.use('/api/upload', uploadRoutes);
        app.use('/api/profile', profileRoutes);

        const PORT = process.env.PORT || 3000;
        app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
    } catch (error) {
        console.error("Error starting server:", error);
        process.exit(1); 
    }
}

startServer();