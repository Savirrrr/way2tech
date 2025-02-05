require('dotenv').config();
const { MongoClient } = require('mongodb');
const port=process.env.PORT||3000
let client;
let collection;
let otpCollection;
let dataCollection;
let uploadCollection;
let profileCollection;

// async function connectDB() {
//   const mongoURI = process.env.MONGO_URI || "mongodb+srv://peecharasavir:DLv37jsi391FY9MR@cluster0.jv90ftt.mongodb.net/?retryWrites=true&w=majority";
//   try {
//     client = new MongoClient(mongoURI);
//     await client.connect();

//     collection = client.db("user_info").collection("users");
//     otpCollection = client.db("user_info").collection("otp_tokens");
//     dataCollection=client.db("user_info").collection("data");
//     uploadCollection=client.db("user_info").collection("uploads")
//     console.log("Connected to MongoDB!");
    
//   } catch (err) {
//     console.error(err);
//     process.exit(1);
//   }
// }
const initializeDB = async () => {
  try {
    const mongoURI = process.env.MONGO_URI || "mongodb+srv://peecharasavir:DLv37jsi391FY9MR@cluster0.jv90ftt.mongodb.net/?retryWrites=true&w=majority";
    
    if (!client) {
      client = new MongoClient(mongoURI, {
        maxPoolSize: 50,
        wtimeoutMS: 2500,
        useNewUrlParser: true,
      });
      
      await client.connect();
      console.log("MongoDB connected successfully.");
    }

    if (!collection) {
      const db = client.db("user_info");
      collection = db.collection("users");
      otpCollection = db.collection("otp_tokens");
      dataCollection = db.collection("data");
      uploadCollection = db.collection("uploads");
      profileCollection = db.collection("profiles"); // Initialize profile collection
    }

    // Add error handling
    client.on('error', (error) => {
      console.error('MongoDB connection error:', error);
    });

    client.on('close', () => {
      console.log('MongoDB connection closed');
      client = null; // Reset client so it can reconnect
    });

    return { 
      client, 
      collection, 
      otpCollection, 
      dataCollection, 
      uploadCollection, 
      profileCollection 
    };
  } catch (error) {
    console.error('Failed to connect to MongoDB:', error);
    throw error;
  }
};
const getDB = () => {
  if (!client || !collection || !otpCollection || !dataCollection || !uploadCollection|| !profileCollection) {
      throw new Error("Database not initialized. Call initializeDB() first.");
  }
  return { client, collection , otpCollection, dataCollection, uploadCollection,profileCollection};
};

module.exports = {initializeDB,getDB};