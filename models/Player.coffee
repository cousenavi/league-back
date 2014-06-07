mongoose = require 'mongoose'

playerSchema = new mongoose.Schema(
  name: String,
  team: String,
  birthday: Date,
  number: Number
)
module.exports = mongoose.model('players', playerSchema)