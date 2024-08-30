// package main

// import (
// 	"context"
// 	"crypto/rand"
// 	"encoding/hex"
// 	"encoding/json"
// 	"fmt"
// 	"log"
// 	"net/http"
// 	"strings"
// 	"time"

// 	"go.mongodb.org/mongo-driver/bson"
// 	"go.mongodb.org/mongo-driver/mongo"
// 	"go.mongodb.org/mongo-driver/mongo/options"
// 	"go.mongodb.org/mongo-driver/mongo/writeconcern"
// 	"golang.org/x/crypto/bcrypt"
// 	"gopkg.in/gomail.v2"
// )

// type User struct {
// 	Email    string `json:"email" bson:"email"`
// 	Password string `json:"password" bson:"password"`
// }

// type Address struct {
// 	Email string `json:"email" bson:"email"`
// }

// type ResetToken struct {
// 	Email     string    `bson:"email"`
// 	Token     string    `bson:"token"`
// 	ExpiresAt time.Time `bson:"expires_at"`
// }

// var collection *mongo.Collection
// var tokenCollection *mongo.Collection

// func connectDB() {
// 	clientOptions := options.Client().ApplyURI("mongodb+srv://peecharasavir:DLv37jsi391FY9MR@cluster0.jv90ftt.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0")

// 	client, err := mongo.Connect(context.TODO(), clientOptions)
// 	if err != nil {
// 		log.Fatal(err)
// 	}

// 	err = client.Ping(context.TODO(), nil)
// 	if err != nil {
// 		log.Fatal(err)
// 	}

// 	wc := writeconcern.New(writeconcern.WMajority())
// 	clientOptions.SetWriteConcern(wc)

// 	collection = client.Database("user_info").Collection("users")
// 	tokenCollection = client.Database("user_info").Collection("tokens")
// 	fmt.Println("Connected to MongoDB!")
// }

// func enableCors(next http.Handler) http.Handler {
// 	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
// 		w.Header().Set("Access-Control-Allow-Origin", "*")
// 		w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
// 		w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
// 		if r.Method == "OPTIONS" {
// 			w.WriteHeader(http.StatusOK)
// 			return
// 		}
// 		next.ServeHTTP(w, r)
// 	})
// }

// func signUpHandler(w http.ResponseWriter, r *http.Request) {
// 	if r.Method == http.MethodPost {
// 		var user User

// 		err := json.NewDecoder(r.Body).Decode(&user)
// 		if err != nil {
// 			log.Printf("Error decoding JSON: %v", err)
// 			http.Error(w, err.Error(), http.StatusBadRequest)
// 			return
// 		}

// 		user.Email = strings.ToLower(user.Email)

// 		hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
// 		if err != nil {
// 			log.Printf("Error hashing password: %v", err)
// 			http.Error(w, err.Error(), http.StatusInternalServerError)
// 			return
// 		}

// 		user.Password = string(hashedPassword)

// 		_, err = collection.InsertOne(context.TODO(), user)
// 		if err != nil {
// 			log.Printf("Error inserting user into database: %v", err)
// 			http.Error(w, err.Error(), http.StatusInternalServerError)
// 			return
// 		}

// 		log.Printf("User signed up successfully: %s", user.Email)
// 		w.WriteHeader(http.StatusOK)
// 		w.Write([]byte("User signed up successfully"))
// 	} else {
// 		log.Printf("Invalid request method: %v", r.Method)
// 		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
// 	}
// }

// func loginHandler(w http.ResponseWriter, r *http.Request) {
// 	if r.Method == http.MethodPost {
// 		var user User

// 		err := json.NewDecoder(r.Body).Decode(&user)
// 		if err != nil {
// 			log.Printf("Error decoding JSON: %v", err)
// 			http.Error(w, err.Error(), http.StatusBadRequest)
// 			return
// 		}

// 		user.Email = strings.ToLower(user.Email)

// 		log.Printf("Logging in with email: %s", user.Email)

// 		var storedUser User
// 		err = collection.FindOne(context.TODO(), bson.M{"email": user.Email}).Decode(&storedUser)

// 		if err != nil {
// 			if err == mongo.ErrNoDocuments {
// 				log.Printf("User not found in database: %s", user.Email)
// 				http.Error(w, "User not found", http.StatusUnauthorized)
// 			} else {
// 				log.Printf("Error finding user in database: %v", err)
// 				http.Error(w, err.Error(), http.StatusInternalServerError)
// 			}
// 			return
// 		}

// 		log.Printf("User found: %s", storedUser.Email)

// 		err = bcrypt.CompareHashAndPassword([]byte(storedUser.Password), []byte(user.Password))
// 		if err != nil {
// 			log.Printf("Invalid password for user: %s", user.Email)
// 			http.Error(w, "Invalid password", http.StatusUnauthorized)
// 			return
// 		}

// 		log.Printf("User logged in successfully: %s", user.Email)

// 		w.WriteHeader(http.StatusOK)

// 		w.Write([]byte("User logged in successfully"))
// 	} else {
// 		log.Printf("Invalid request method: %v", r.Method)

// 		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
// 	}
// }

// func generateToken() (string, error) {
// 	bytes := make([]byte, 32)
// 	if _, err := rand.Read(bytes); err != nil {
// 		return "", err
// 	}
// 	return hex.EncodeToString(bytes), nil
// }

// func sendEmail(to string, subject string, body string) error {
// 	from := "mailer.learnx@gmail.com"
// 	password := "glfd kcgf dhpx hiwk"
// 	//from savirp1905 password wdqk tdot bdxk laep
// 	//from mailer.learnx password glfd kcgf dhpx hiwk
// 	// from := "savirp1905@gmail.com"
// 	// password := /*"LearnX.mailer"*/ "wdqk tdot bdxk laep"

// 	// Set up the email message
// 	msg := gomail.NewMessage()
// 	msg.SetHeader("From", from)
// 	msg.SetHeader("To", to)
// 	msg.SetHeader("Subject", subject)
// 	msg.SetBody("text/plain", body)

// 	// Set up the dialer
// 	dialer := gomail.NewDialer("smtp.gmail.com", 587, from, password)

// 	// Send the email
// 	err := dialer.DialAndSend(msg)
// 	if err != nil {
// 		log.Printf("Error sending email to %s: %v", to, err)
// 		return err
// 	}

// 	log.Printf("Email sent successfully to %s", to)
// 	return nil
// }

// func forgotpwd(w http.ResponseWriter, r *http.Request) {
// 	if r.Method == http.MethodPost {
// 		var user Address

// 		err := json.NewDecoder(r.Body).Decode(&user)
// 		if err != nil {
// 			log.Printf("Error decoding JSON: %v", err)
// 			http.Error(w, err.Error(), http.StatusBadRequest)
// 			return
// 		}

// 		user.Email = strings.ToLower(user.Email)

// 		log.Printf("Changing password for email: %s", user.Email)

// 		var storedUser Address
// 		err = collection.FindOne(context.TODO(), bson.M{"email": user.Email}).Decode(&storedUser)
// 		if err != nil {
// 			log.Printf("Query used: %v", bson.M{"email": user.Email})
// 			if err == mongo.ErrNoDocuments {
// 				log.Printf("User not found in database: %s", user.Email)
// 				http.Error(w, "User not found", http.StatusUnauthorized)
// 			} else {
// 				log.Printf("Error finding user in database: %v", err)
// 				http.Error(w, err.Error(), http.StatusInternalServerError)
// 			}
// 			return
// 		}

// 		log.Printf("User found: %s", storedUser.Email)

// 		token, err := generateToken()
// 		if err != nil {
// 			log.Printf("Error generating token: %v", err)
// 			http.Error(w, "Error generating token", http.StatusInternalServerError)
// 			return
// 		}

// 		expirationTime := time.Now().Add(1 * time.Hour)
// 		resetToken := ResetToken{
// 			Email:     storedUser.Email,
// 			Token:     token,
// 			ExpiresAt: expirationTime,
// 		}

// 		_, err = tokenCollection.InsertOne(context.TODO(), resetToken)
// 		if err != nil {
// 			log.Printf("Error saving token in database: %v", err)
// 			http.Error(w, "Error saving token", http.StatusInternalServerError)
// 			return
// 		}

// 		resetURL := fmt.Sprintf("https://mycsutomscheme/resetpassword?token=%s", token)
// 		emailBody := fmt.Sprintf("Click the following link to reset your password: %s", resetURL)

// 		// Print the reset URL to the console
// 		log.Printf("Generated reset URL: %s", resetURL)

// 		err = sendEmail(storedUser.Email, "Password Reset", emailBody)
// 		if err != nil {
// 			log.Printf("Error sending email: %v", err)
// 			http.Error(w, "Error sending email", http.StatusInternalServerError)
// 			return
// 		}

// 		log.Printf("Password reset email sent to: %s", storedUser.Email)
// 		w.WriteHeader(http.StatusOK)
// 		w.Write([]byte("Password reset email sent"))
// 	} else {
// 		log.Printf("Invalid request method: %v", r.Method)
// 		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
// 	}
// }

// func hashPassword(password string) (string, error) {
// 	bytes, err := bcrypt.GenerateFromPassword([]byte(password), 14)
// 	return string(bytes), err
// }

// func verifyTokenAndResetPassword(w http.ResponseWriter, r *http.Request) {
// 	switch r.Method {
// 	case http.MethodGet:
// 		// Handle the GET request: This could be to verify the token or just confirm it's a valid request
// 		token := r.URL.Query().Get("token")
// 		if token == "" {
// 			http.Error(w, "Token is required", http.StatusBadRequest)
// 			return
// 		}
// 		// Optionally, verify the token exists in your database
// 		// This part might not be strictly necessary, as the main validation happens on POST
// 		var resetToken ResetToken
// 		err := tokenCollection.FindOne(context.TODO(), bson.M{"token": token}).Decode(&resetToken)
// 		if err != nil {
// 			if err == mongo.ErrNoDocuments {
// 				http.Error(w, "Invalid or expired token", http.StatusUnauthorized)
// 				return
// 			}
// 			http.Error(w, "Internal server error", http.StatusInternalServerError)
// 			return
// 		}

// 		// You can send a simple response to indicate the token is valid (or proceed directly in the app)
// 		w.WriteHeader(http.StatusOK)
// 		w.Write([]byte("Token is valid"))
// 	case http.MethodPost:
// 		var reqData struct {
// 			Token       string `json:"token"`
// 			NewPassword string `json:"newPassword"`
// 		}

// 		err := json.NewDecoder(r.Body).Decode(&reqData)
// 		if err != nil {
// 			log.Printf("Error decoding JSON: %v", err)
// 			http.Error(w, "Invalid request body", http.StatusBadRequest)
// 			return
// 		}

// 		var resetToken ResetToken
// 		err = tokenCollection.FindOne(context.TODO(), bson.M{"token": reqData.Token}).Decode(&resetToken)
// 		if err != nil {
// 			if err == mongo.ErrNoDocuments {
// 				log.Printf("Invalid or expired token: %s", reqData.Token)
// 				http.Error(w, "Invalid or expired token", http.StatusUnauthorized)
// 			} else {
// 				log.Printf("Error finding token in database: %v", err)
// 				http.Error(w, "Internal server error", http.StatusInternalServerError)
// 			}
// 			return
// 		}

// 		if time.Now().After(resetToken.ExpiresAt) {
// 			log.Printf("Token has expired: %s", reqData.Token)
// 			http.Error(w, "Token has expired", http.StatusUnauthorized)
// 			return
// 		}

// 		// Update the user's password
// 		hashedPassword, err := hashPassword(reqData.NewPassword)
// 		if err != nil {
// 			log.Printf("Error hashing password: %v", err)
// 			http.Error(w, "Error hashing password", http.StatusInternalServerError)
// 			return
// 		}

// 		_, err = collection.UpdateOne(context.TODO(),
// 			bson.M{"email": resetToken.Email},
// 			bson.M{"$set": bson.M{"password": hashedPassword}})
// 		if err != nil {
// 			log.Printf("Error updating password: %v", err)
// 			http.Error(w, "Error updating password", http.StatusInternalServerError)
// 			return
// 		}

// 		log.Printf("Password updated for user: %s", resetToken.Email)

// 		// Optionally, you can remove the token from the database after it has been used
// 		_, err = tokenCollection.DeleteOne(context.TODO(), bson.M{"token": reqData.Token})
// 		if err != nil {
// 			log.Printf("Error deleting used token: %v", err)
// 		}

// 		w.WriteHeader(http.StatusOK)
// 		w.Write([]byte("Password updated successfully"))
// 	default:
// 		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
// 	}
// }

// // func resetPasswordGETHandler(w http.ResponseWriter, r *http.Request) {
// // 	if r.Method != http.MethodGet {
// // 		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
// // 		return
// // 	}

// // 	// Extract the token from query parameters
// // 	token := r.URL.Query().Get("token")
// // 	if token == "" {
// // 		http.Error(w, "Token is required", http.StatusBadRequest)
// // 		return
// // 	}

// // 	// Validate the token (as in your POST handler)
// // 	var resetToken ResetToken
// // 	if err := tokenCollection.FindOne(context.TODO(), bson.M{"token": token}).Decode(&resetToken); err != nil {
// // 		if err == mongo.ErrNoDocuments {
// // 			http.Error(w, "Invalid or expired token", http.StatusUnauthorized)
// // 		} else {
// // 			http.Error(w, "Internal server error", http.StatusInternalServerError)
// // 		}
// // 		return
// // 	}

// // 	// Respond with a simple message or JSON response
// // 	fmt.Fprintf(w, "Token is valid. Please use the app to reset your password.")
// // }

// // func resetPasswordHandler(w http.ResponseWriter, r *http.Request) {
// // 	switch r.Method {
// // 	case http.MethodGet:
// // 		// Handle GET request (show a message or perform some validation)
// // 		token := r.URL.Query().Get("token")
// // 		if token == "" {
// // 			http.Error(w, "Token is required", http.StatusBadRequest)
// // 			return
// // 		}
// // 		// Validate the token as you would in the POST method
// // 		// fmt.Fprintf(w, "Token is valid. Please use the app to reset your password.")

// // 	case http.MethodPost:
// // 		// Your existing POST logic to handle password reset
// // 		var reqBody struct {
// // 			Token    string `json:"token"`
// // 			Password string `json:"password"`
// // 		}

// // 		if err := json.NewDecoder(r.Body).Decode(&reqBody); err != nil {
// // 			http.Error(w, "Invalid request body", http.StatusBadRequest)
// // 			return
// // 		}

// // 		// Validate that both the token and password are provided
// // 		if reqBody.Token == "" || reqBody.Password == "" {
// // 			log.Printf("Token or password not provided")
// // 			http.Error(w, "Token and password must be provided", http.StatusBadRequest)
// // 			return
// // 		}

// // 		// Find the reset token in the database
// // 		var resetToken ResetToken
// // 		if err := tokenCollection.FindOne(context.TODO(), bson.M{"token": reqBody.Token}).Decode(&resetToken); err != nil {
// // 			if err == mongo.ErrNoDocuments {
// // 				log.Printf("Invalid or expired token: %s", reqBody.Token)
// // 				http.Error(w, "Invalid or expired token", http.StatusUnauthorized)
// // 			} else {
// // 				log.Printf("Error finding token in database: %v", err)
// // 				http.Error(w, "Internal server error", http.StatusInternalServerError)
// // 			}
// // 			return
// // 		}

// // 		// Check if the token has expired
// // 		if time.Now().After(resetToken.ExpiresAt) {
// // 			log.Printf("Token has expired: %s", reqBody.Token)
// // 			http.Error(w, "Token has expired", http.StatusUnauthorized)
// // 			return
// // 		}

// // 		// Hash the new password
// // 		hashedPassword, err := bcrypt.GenerateFromPassword([]byte(reqBody.Password), bcrypt.DefaultCost)
// // 		if err != nil {
// // 			log.Printf("Error hashing password: %v", err)
// // 			http.Error(w, "Internal server error", http.StatusInternalServerError)
// // 			return
// // 		}

// // 		// Update the user's password in the database
// // 		updateResult, err := collection.UpdateOne(
// // 			context.TODO(),
// // 			bson.M{"email": resetToken.Email},
// // 			bson.M{"$set": bson.M{"password": string(hashedPassword)}},
// // 		)
// // 		if err != nil {
// // 			log.Printf("Error updating user password: %v", err)
// // 			http.Error(w, "Internal server error", http.StatusInternalServerError)
// // 			return
// // 		}

// // 		// Check if the password was actually updated
// // 		if updateResult.ModifiedCount == 0 {
// // 			log.Printf("No document was updated for email: %s", resetToken.Email)
// // 			http.Error(w, "Failed to update password", http.StatusInternalServerError)
// // 			return
// // 		}

// // 		// Delete the used reset token from the database
// // 		if _, err := tokenCollection.DeleteOne(context.TODO(), bson.M{"token": reqBody.Token}); err != nil {
// // 			log.Printf("Error deleting token: %v", err)
// // 			// Do not return an error response as the password was updated successfully
// // 		}

// // 		log.Printf("Password reset successfully for email: %s", resetToken.Email)
// // 		w.WriteHeader(http.StatusOK)
// // 		w.Write([]byte("Password reset successfully"))
// // 	default:
// // 		http.Error(w, "Invalid request Method", http.StatusMethodNotAllowed)
// // 	}
// // }

// func main() {
// 	connectDB()

// 	http.HandleFunc("/signup", signUpHandler)
// 	http.HandleFunc("/login", loginHandler)
// 	http.HandleFunc("/forgotpwd", forgotpwd)
// 	http.HandleFunc("/resetpassword", verifyTokenAndResetPassword) // Handles POST requests

// 	srv := &http.Server{
// 		Addr:         ":3000",
// 		Handler:      enableCors(http.DefaultServeMux),
// 		WriteTimeout: 15 * time.Second,
// 		ReadTimeout:  15 * time.Second,
// 		IdleTimeout:  60 * time.Second,
// 	}

// 	fmt.Println("Server is running on port 3000...")
// 	log.Fatal(srv.ListenAndServe())
// }
const express = require('express');
const bcrypt = require('bcrypt');
const crypto = require('crypto');
const nodemailer = require('nodemailer');
const { MongoClient, ObjectId } = require('mongodb');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

const client = new MongoClient("mongodb+srv://peecharasavir:DLv37jsi391FY9MR@cluster0.jv90ftt.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");

let collection;
let tokenCollection;

async function connectDB() {
    try {
        await client.connect();
        collection = client.db("user_info").collection("users");
        tokenCollection = client.db("user_info").collection("tokens");
        console.log("Connected to MongoDB!");
    } catch (err) {
        console.error(err);
        process.exit(1);
    }
}

app.post('/signup', async (req, res) => {
    if (req.method === 'POST') {
        const user = req.body;

        user.email = user.email.toLowerCase();

        try {
            const hashedPassword = await bcrypt.hash(user.password, 10);
            user.password = hashedPassword;

            await collection.insertOne(user);
            console.log(`User signed up successfully: ${user.email}`);
            res.status(200).send('User signed up successfully');
        } catch (err) {
            console.error(`Error inserting user into database: ${err}`);
            res.status(500).send(err.message);
        }
    } else {
        console.log(`Invalid request method: ${req.method}`);
        res.status(405).send('Invalid request method');
    }
});

app.post('/login', async (req, res) => {
    if (req.method === 'POST') {
        const user = req.body;
        user.email = user.email.toLowerCase();

        console.log(`Logging in with email: ${user.email}`);

        try {
            const storedUser = await collection.findOne({ email: user.email });

            if (!storedUser) {
                console.log(`User not found in database: ${user.email}`);
                res.status(401).send('User not found');
                return;
            }

            console.log(`User found: ${storedUser.email}`);

            const isMatch = await bcrypt.compare(user.password, storedUser.password);
            if (!isMatch) {
                console.log(`Invalid password for user: ${user.email}`);
                res.status(401).send('Invalid password');
                return;
            }

            console.log(`User logged in successfully: ${user.email}`);
            res.status(200).send('User logged in successfully');
        } catch (err) {
            console.error(`Error finding user in database: ${err}`);
            res.status(500).send(err.message);
        }
    } else {
        console.log(`Invalid request method: ${req.method}`);
        res.status(405).send('Invalid request method');
    }
});

function generateToken() {
    return crypto.randomBytes(32).toString('hex');
}

async function sendEmail(to, subject, body) {
    const from = 'mailer.learnx@gmail.com';
    const password = 'glfd kcgf dhpx hiwk';
    //from savirp1905 password wdqk tdot bdxk laep
    //from mailer.learnx password glfd kcgf dhpx hiwk
    // from savirp1905@gmail.com password wdqk tdot bdxk laep

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

app.post('/forgotpwd', async (req, res) => {
    if (req.method === 'POST') {
        const user = req.body;
        user.email = user.email.toLowerCase();

        console.log(`Changing password for email: ${user.email}`);

        try {
            const storedUser = await collection.findOne({ email: user.email });
            if (!storedUser) {
                console.log(`User not found in database: ${user.email}`);
                res.status(401).send('User not found');
                return;
            }

            console.log(`User found: ${storedUser.email}`);

            const token = generateToken();
            const expirationTime = new Date(Date.now() + 3600000); // 1 hour

            const resetToken = {
                email: storedUser.email,
                token: token,
                expires_at: expirationTime
            };

            await tokenCollection.insertOne(resetToken);

            const resetURL = `https://mycsutomscheme/resetpassword?token=${token}`;
            const emailBody = `Click the following link to reset your password: ${resetURL}`;

            console.log(`Generated reset URL: ${resetURL}`);

            await sendEmail(storedUser.email, 'Password Reset', emailBody);

            console.log(`Password reset email sent to: ${storedUser.email}`);
            res.status(200).send('Password reset email sent');
        } catch (err) {
            console.error(`Error processing password reset: ${err}`);
            res.status(500).send(err.message);
        }
    } else {
        console.log(`Invalid request method: ${req.method}`);
        res.status(405).send('Invalid request method');
    }
});

app.all('/resetpassword', async (req, res) => {
    if (req.method === 'GET') {
        const token = req.query.token;
        if (!token) {
            res.status(400).send('Token is required');
            return;
        }

        try {
            const resetToken = await tokenCollection.findOne({ token: token });
            if (!resetToken) {
                res.status(401).send('Invalid or expired token');
                return;
            }

            res.status(200).send('Token is valid');
        } catch (err) {
            console.error(`Error validating token: ${err}`);
            res.status(500).send('Internal server error');
        }
    } else if (req.method === 'POST') {
        const { token, newPassword } = req.body;

        try {
            const resetToken = await tokenCollection.findOne({ token: token });
            if (!resetToken) {
                console.log(`Invalid or expired token: ${token}`);
                res.status(401).send('Invalid or expired token');
                return;
            }

            if (new Date() > resetToken.expires_at) {
                console.log(`Token has expired: ${token}`);
                res.status(401).send('Token has expired');
                return;
            }

            const hashedPassword = await bcrypt.hash(newPassword, 10);

            await collection.updateOne({ email: resetToken.email }, { $set: { password: hashedPassword } });

            console.log(`Password updated for user: ${resetToken.email}`);

            await tokenCollection.deleteOne({ token: token });

            res.status(200).send('Password updated successfully');
        } catch (err) {
            console.error(`Error resetting password: ${err}`);
            res.status(500).send('Internal server error');
        }
    } else {
        res.status(405).send('Invalid request method');
    }
});

async function startServer() {
    await connectDB();

    const PORT = 3000;
    app.listen(PORT, () => {
        console.log(`Server is running on port ${PORT}...`);
    });
}

startServer();
