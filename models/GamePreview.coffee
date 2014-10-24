module.exports = ->

  mongoose = require 'mongoose'

  simpleTableSchema = new mongoose.Schema(
    leagueId: mongoose.Schema.Types.ObjectId,
    gameId: mongoose.Schema.Types.ObjectId,
    placeName: String,
    refereeName: String,
    tourNumber: Number,
    maxScored: Number,
    maxConceded: Number,
    date: String,
    time: String,
    teams: Array
  )

  mongoose.model('gamepreviews', simpleTableSchema)