const { MongoClient } = require('mongodb');

let client;
let collections = {};

async function connectDB() {
  const mongoURI = process.env.MONGO_URI || "mongodb://localhost:27017";
  try {
    client = new MongoClient(mongoURI);
    await client.connect();
    console.log("Connected to MongoDB!");

    const db = client.db("user_info");
    collections.users = db.collection("users");
    collections.otpTokens = db.collection("otp_tokens");
    collections.uploads = db.collection("uploads");
    // return collections;
  } catch (err) {
    console.error(err);
    process.exit(1);
  }
}

module.exports = { connectDB, collections };