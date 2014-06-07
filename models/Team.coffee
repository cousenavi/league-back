mongoose = require 'mongoose'

teamSchema = new mongoose.Schema(
  name: {type: String, index: {unique: true}},
  league: String
)
module.exports = mongoose.model('teams', teamSchema)