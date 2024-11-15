const express = require('express');
const bcrypt = require('bcrypt');
const crypto = require('crypto');
const nodemailer = require('nodemailer');
const { MongoClient, ObjectId } = require('mongodb');
const cors = require('cors');
const multer = require('multer');
const fs = require('fs');
const { emit } = require('process');
const path=require('path');
const { log } = require('console');

const app = express();
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, '../../views'));
app.use(express.json());
app.use(express.urlencoded({ extended: true })); 
app.use(cors());

const client = new MongoClient("mongodb+srv://peecharasavir:DLv37jsi391FY9MR@cluster0.jv90ftt.mongodb.net/?retryWrites=true&w=majority");

let i;
let collection;
let otpCollection;
let dataCollection;
let uploadCollection;
let tempUploads = {}; 

async function connectDB() {
    try {
        await client.connect();
        collection = client.db("user_info").collection("users");
        otpCollection = client.db("user_info").collection("otp_tokens");
        dataCollection=client.db("user_info").collection("data");
        uploadCollection=client.db("user_info").collection("uploads")
        console.log("Connected to MongoDB!");
    } catch (err) {
        console.error(err);
        process.exit(1);
    }
}

// Serve the upload page
// app.get("/", (req, res) => {
//     res.render("upload.ejs");
// });

// Set up multer for file uploads
const storage = multer.memoryStorage(); 
const upload = multer({ storage: storage });

app.post('/upload', upload.single('media'), async (req, res) => {
    const { title, caption , email} = req.body;
    let mediaData;
    let mediaContentType;
    let mediaOriginalName;

    if (req.file) {
        mediaData = req.file.buffer;
        mediaContentType = req.file.mimetype;
        mediaOriginalName = req.file.originalname;
    } else {
        mediaData = fs.readFileSync('path/to/default.jpg');
        mediaContentType = 'image/jpeg';
        mediaOriginalName = 'default.jpg';
    }
    console.log(caption);
    
    const tempId = new ObjectId(); 
    tempUploads[tempId] = {
        index:i,
        title:title,
        userId: email,
        text: caption,
        media: {
            data: mediaData,
            contentType: mediaContentType,
            originalName: mediaOriginalName
        },
        uploadedAt: new Date(),
    };
    i+=1;

    try {
        await sendApprovalEmail(tempId,caption, title,mediaData, mediaContentType, mediaOriginalName,email);
        res.status(200).send('Email sent for approval');
    } catch (err) {
        console.error(`Error sending email: ${err}`);
        res.status(500).send('Error sending email');
    }
});

async function sendApprovalEmail(tempId,title, caption,mediaData, mediaContentType, mediaOriginalName,email) {
    const editLink = `http://localhost:3000/edit/${tempId}`;
    const rejectLink = `http://localhost:3000/reject/${tempId}`;

    const from = 'mailer.learnx@gmail.com';
    const password = 'glfd kcgf dhpx hiwk';

    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: from,
            pass: password
        }
    });

    let mailOptions = {
        from: from,
        to: from,
        subject: 'Upload Approval Required',
        html: `
            <p>User ID: ${email}</p>
            <p>Title: ${title}</p>
            <p>Body : ${caption}</p>
            <p>Please review the upload and approve or reject it:</p>
            <a href="${editLink}">Accept and Edit</a> | <a href="${rejectLink}">Reject</a>
        `,
        attachments: [
            {
                filename: mediaOriginalName,
                content: mediaData,
                contentType: mediaContentType
            }
        ]
    };

    await transporter.sendMail(mailOptions);
    console.log("function validated");
    // res.status(200).send('Your request has been sent for verification');
    
}

// Route to handle rejection of an upload
app.get('/reject/:tempId', (req, res) => {
    const tempId = req.params.tempId;

    if (tempUploads[tempId]) {
        delete tempUploads[tempId]; 
        res.send('Upload rejected');
    } else {
        res.status(404).send('No pending upload found for this ID');
    }
});

// Route to display the edit form for an upload
app.get('/edit/:tempId', (req, res) => {
    const tempId = req.params.tempId;
    console.log(req.body);
    
    if (tempUploads[tempId]) {
        res.render('edit', { data: tempUploads[tempId], tempId });
    } else {
        res.status(404).send('No pending upload found for this ID');
    }
});

// Route to handle edit form submission and save data to the database
app.post('/edit/:tempId', async (req, res) => {
    const tempId = req.params.tempId;
    const { text, userId } = req.body;
    console.log(req.body);
    

    if (tempUploads[tempId]) {
        tempUploads[tempId].text = text;
        tempUploads[tempId].userId = userId;

        try {
            await uploadCollection.insertOne(tempUploads[tempId]);
            delete tempUploads[tempId];
            res.send('Data saved to the database successfully');
        } catch (err) {
            console.error(`Error saving data to database: ${err}`);
            res.status(500).send('Internal server error');
        }
    } else {
        res.status(404).send('No pending upload found for this ID');
    }
});

app.get('/check-username/:username', async (req,res)=>{
    try
    {
    const userName=req.params;
    const user=await collection.findOne({username:userName});
    if (user) {
        // If the user exists, send a response indicating the username is taken
        return res.status(200).json({ isTaken: true });
      } else {
        // If the user does not exist, send a response indicating the username is available
        return res.status(200).json({ isTaken: false });
      }
    } catch (error) {
      console.error('Error checking username:', error);
      return res.status(500).json({ error: 'Internal server error' });
    }
});

//to retreive max index of the uploaded data
app.get('/maxIndex', async (req, res) => {
    try {
      res.status(200).send(i.toString());
      console.log("index",i);
      
    } catch (err) {
      console.error('Error retrieving max index:', err);
      res.status(500).send('Internal server error');
    }
  });
  

//retreive uploaded data
app.post('/retreiveData', async (req, res) => {
    try {
        const { index } = req.body; 
        console.log("received index",i);
        // Extract index from request body
        const data = await uploadCollection.findOne({ index: (parseInt(index)) }); // Make sure index is an integer

        if (data) {
            // console.log(data);
            console.log(data.media,data.userId,data.title,data.text);
            
            res.status(200).send(data/*.title,data.text.userId,data.media*/);
        } else {
            console.log("Error finding data");
            res.status(404).send("No data found");
        }
    } catch (err) {
        console.error('Error retrieving data:', err);
        res.status(500).send('Internal server error');
    }
});

// Store user details temporarily with OTP
app.post('/signup', async (req, res) => {
    const user = req.body;
    user.email = user.email.toLowerCase();

    try {
        const hashedPassword = await bcrypt.hash(user.password, 10);

        await otpCollection.deleteMany({ email: user.email });

        const otp = Math.floor(100000 + Math.random() * 900000).toString();
        const expirationTime = new Date(Date.now() + 10 * 60 * 1000);

        console.log(`Generated OTP: ${otp}, Expiration Time: ${expirationTime}`);
        console.log(user.username);
        
        const insertResult = await otpCollection.insertOne({
            fname:user.firstName,
            lname:user.lastName,
            username:user.username,
            email: user.email,
            password: hashedPassword,
            otp,
            expires_at: expirationTime,
            verified: false 
        },{writeConsern:{w:"majority"} });

        console.log(`OTP Insertion Result: ${JSON.stringify(insertResult)}`);
        const insertedOtp = await otpCollection.findOne({ _id: insertResult.insertedId });

        console.log('Inserted OTP Document:', insertedOtp);

        // if (insertResult.insertedCount === 0) {
        //     console.error('Failed to insert OTP into the database');
        //     res.status(500).send('Failed to generate OTP. Please try again.');
        //     return;
        // }

        const emailBody = `Your OTP code is: ${otp}`;
        await sendEmail(user.email, 'Account Verification OTP', emailBody);
        console.log(`OTP sent to: ${user.email}`);

        res.status(200).send('User signed up successfully. Please verify your email.');
    } catch (err) {
        console.error(`Error during signup: ${err}`);
        res.status(500).send('Internal server error');
    }
});

// Verify OTP and move user details to the main collection
app.post('/verifySignupOtp', async (req, res) => {
    const { email, username, otp } = req.body;
    console.log(username);
    
    try {
        const emailLower = email.toLowerCase();
        const otpRecord = await otpCollection.findOne({ email: emailLower, otp });

        if (!otpRecord) {
            console.log('OTP record not found or mismatch');
            res.status(401).send('Invalid or expired OTP');
            return;
        }

        if (new Date() > otpRecord.expires_at) {
            console.log('OTP expired');
            res.status(401).send('Invalid or expired OTP');
            return;
        }

        // Insert user data into the main collection
        const userData = {
            username: username,
            firstname: otpRecord.fname,
            lastname: otpRecord.lname,
            email: otpRecord.email,
            password: otpRecord.password
        };

        await collection.insertOne(userData);
        await otpCollection.deleteOne({ email: emailLower, otp });

        res.status(200).send('User verified and added to database');
    } catch (err) {
        console.error(`Error verifying OTP: ${err}`);
        res.status(500).send('Internal server error');
    }
});

async function sendEmail(to, subject, body) {
    const from = 'mailer.learnx@gmail.com';
    const password = 'glfd kcgf dhpx hiwk';

    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: from,
            pass: password
        }
    });

    const mailOptions = {
        from: from,
        to: to,
        subject: subject,
        text: body
    };

    try {
        await transporter.sendMail(mailOptions);
        console.log(`Email sent successfully to ${to}`);
    } catch (err) {
        console.error(`Error sending email to ${to}: ${err}`);
    }
}

// Handle login
app.post('/login', async (req, res) => {
    const { emailOrUsername, password } = req.body;
    console.log("LOGIN");
    console.log(emailOrUsername,password);
    
    // Check if emailOrUsername and password are provided
    if (!emailOrUsername || !password) {
        return res.status(400).send('Email/Username and password are required');
    }

    console.log(`Login attempt with: ${emailOrUsername}`);

    try {
        // Check if it's an email or a username
        let searchQuery;
        if (emailOrUsername.includes('@')) {
            // If it's an email, make it case-insensitive
            searchQuery = { email: { $regex: new RegExp(`^${emailOrUsername}$`, 'i') } };
        } else {
            // If it's a username, don't change the case
            searchQuery = { username: emailOrUsername };
        }

        // Search for the user by either email or username
        const storedUser = await collection.findOne(searchQuery);

        if (!storedUser) {
            console.log(`User not found for: ${emailOrUsername}`);
            return res.status(401).send('Incorrect username/email or password');
        }

        console.log(`User found: ${storedUser.email}`);

        // Compare the provided password with the stored hashed password
        const isMatch = await bcrypt.compare(password, storedUser.password);
        if (!isMatch) {
            console.log(`Incorrect password for user: ${emailOrUsername}`);
            return res.status(401).send('Incorrect username/email or password');
        }

        console.log(`User logged in successfully: ${emailOrUsername}`);
        return res.status(200).send('User logged in successfully');
    } catch (err) {
        console.error(`Error during login: ${err}`);
        return res.status(500).send('Internal server error');
    }
});


// Handle forgot password
app.post('/forgotpwd', async (req, res) => {
    const { email } = req.body;

    try {
        await otpCollection.deleteMany({ email: email.toLowerCase() });

        const otp = Math.floor(100000 + Math.random() * 900000).toString();
        const expirationTime = new Date(Date.now() + 10 * 60 * 1000);

        await otpCollection.insertOne({ email: email.toLowerCase(), otp, expires_at: expirationTime });

        const emailBody = `Your OTP code is: ${otp}`;

        await sendEmail(email, 'Password Reset OTP', emailBody);
        console.log(`OTP sent to: ${email}`);

        res.status(200).send('OTP sent successfully');
    } catch (err) {
        console.error(`Error processing forgot password: ${err}`);
        res.status(500).send('Internal server error');
    }
});

// Verify OTP for forgot password
app.post('/verifyotp', async (req, res) => {
    const { email, otp } = req.body;

    try {
        const otpRecord = await otpCollection.findOne({ email: email.toLowerCase(), otp });

        if (!otpRecord || new Date() > otpRecord.expires_at) {
            res.status(401).send('Invalid or expired OTP');
            return;
        }

        res.status(200).send('OTP verified');
    } catch (err) {
        console.error(`Error verifying OTP: ${err}`);
        res.status(500).send('Internal server error');
    }
});

// Reset password after verifying OTP
app.post('/resetpassword', async (req, res) => {
    const { email, newPassword } = req.body;
    const emailLower = email.toLowerCase();

    try {
        const hashedPassword = await bcrypt.hash(newPassword, 10);

        const result = await collection.updateOne(
            { email: emailLower },
            { $set: { password: hashedPassword } }
        );

        if (result.modifiedCount === 1) {
            res.status(200).send('Password updated successfully');
        } else {
            res.status(400).send('Failed to update password');
        }
    } catch (err) {
        console.error(`Error resetting password: ${err}`);
        res.status(500).send('Internal server error');
    }
});

// Verify OTP for password reset
app.post('/verifyForgotPasswordOtp', async (req, res) => {
    const { email, otp } = req.body;
    const emailLower = email.toLowerCase();

    try {
        const otpRecord = await otpCollection.findOne({ email: emailLower, otp });

        console.log(`OTP record: ${JSON.stringify(otpRecord)}`);
        console.log(`Current Time: ${new Date()}`);
        console.log(`OTP Expiration Time: ${otpRecord ? otpRecord.expires_at : 'No OTP Record Found'}`);

        if (!otpRecord) {
            console.log('OTP record not found or mismatch');
            return res.status(401).send('Invalid or expired OTP');
        }

        if (new Date() > otpRecord.expires_at) {
            console.log('OTP expired');
            return res.status(401).send('Invalid or expired OTP');
        }

        res.status(200).send('OTP verified, proceed to change password');
    } catch (err) {
        console.error(`Error verifying OTP: ${err}`);
        res.status(500).send('Internal server error');
    }
});

app.post("/updateprofileusername", async (req,res)=>{
    const  {uname,updatedUname}=req.body;
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

});

// Start the server
async function startServer() {
    await connectDB();

    const PORT = 3000;
    app.listen(PORT, () => {
        console.log(`Server is running on port ${PORT}...`);
    });
}

startServer();
