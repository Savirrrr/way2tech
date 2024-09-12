const express = require('express');
const { MongoClient } = require('mongodb');
const path = require('path');

const app = express();
const port = 3000;

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

const uri = 'mongodb://localhost:27017'; 
const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true });

app.get('/', async (req, res) => {
    try {
        await client.connect();
        const database = client.db('user_info'); 
        const collection = database.collection('uploads'); 

        const documents = await collection.find({}).toArray();
        console.log(collection);
        if (documents) {
            //console.log(document);
            res.render('display', { documents: documents });
        } else {
            res.send('No document found');
        }
    } catch (err) {
        console.error(err);
        res.send('Error occurred');
    } finally {
        await client.close();
    }
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
