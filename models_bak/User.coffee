mongoose = require 'mongoose'

userSchema = new mongoose.Schema(
  email: {type: String, index: {unique: true}},
  password: String,
  roles: [String]
)
module.exports = mongoose.model('users', userSchema)