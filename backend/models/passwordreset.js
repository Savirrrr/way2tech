const { ObjectId } = require('mongodb');

class PasswordReset {
    constructor(email) {
        this._id = new ObjectId();
        this.email = email;
        this.token = this._id.toString();
        this.createdAt = new Date();
        this.expiresAt = new Date(Date.now() + 3600 * 1000);
    }
}

module.exports = PasswordReset;