module.exports = ->
  mongoose = require 'mongoose'

  playerSchema = new mongoose.Schema(
    name: String
    photo: String

    teamId: mongoose.Schema.Types.ObjectId
    leagueId: mongoose.Schema.Types.ObjectId

    position: String
    number: Number
  )
  mongoose.model('players', playerSchema)