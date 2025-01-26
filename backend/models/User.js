const { ObjectId } = require('mongodb');

class User {
    constructor(username, email, password) {
        this._id = new ObjectId();
        this.username = username;
        this.email = email;
        this.password = password;
        this.createdAt = new Date();
    }
}

module.exports = User;