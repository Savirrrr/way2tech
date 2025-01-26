const bcrypt = require('bcrypt');
const saltRounds = 10;

const hashPassword = async (password) => bcrypt.hash(password, saltRounds);
const comparePassword = async (password, hashedPassword) =>
    bcrypt.compare(password, hashedPassword);

module.exports = { hashPassword, comparePassword };