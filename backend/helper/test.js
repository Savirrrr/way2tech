const express = require('express');
const multer = require('multer');
const bodyParser = require('body-parser');
const { MongoClient, ObjectId } = require('mongodb');
const fs = require('fs');

const app = express();
app.use(express.json());
app.use(bodyParser.urlencoded({ extended: true }));

const client = new MongoClient("mongodb+srv://peecharasavir:DLv37jsi391FY9MR@cluster0.jv90ftt.mongodb.net/?retryWrites=true&w=majority");

let collection;

async function connectDB() {
    try {
        await client.connect();
        collection = client.db("user_info").collection("uploads");
        console.log("Connected to MongoDB!");
    } catch (err) {
        console.error(err);
        process.exit(1);
    }
}

app.get("/", (req, res) => {
    res.render("upload.ejs");
});

const storage = multer.memoryStorage(); 
const upload = multer({ storage: storage });

app.post('/upload', upload.single('media'), async (req, res) => {
    console.log(req.body);
    const { text, userId } = req.body;
    let mediaData;
    let mediaContentType;

    if (req.file) {
        mediaData = req.file.buffer;
        mediaContentType = req.file.mimetype;
    } else {
        mediaData = fs.readFileSync('path/to/default.jpg'); 
        mediaContentType = 'image/jpeg'; 
    }

    const dataToSave = {
        userId: new ObjectId(userId),
        text: text,
        media: {
            data: mediaData,
            contentType: mediaContentType,
        },
        uploadedAt: new Date(),
    };

    try {
        await collection.insertOne(dataToSave);
        console.log(`Data uploaded successfully with userId: ${userId}`);
        res.status(200).send('Data uploaded successfully');
    } catch (err) {
        console.error(`Error saving data to database: ${err}`);
        res.status(500).send('Internal server error');
    }
});

app.post('/cancel', (req, res) => {
    res.redirect('/home');
});

app.get('/home', (req, res) => {
    res.send('Home Page');
});

async function startServer() {
    await connectDB();
    const PORT = 3000;
    app.listen(PORT, () => {
        console.log(`Server is running on port ${PORT}...`);
    });
}
startServer();
