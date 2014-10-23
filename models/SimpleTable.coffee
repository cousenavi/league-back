module.exports = ->

  mongoose = require 'mongoose'

  simpleTableSchema = new mongoose.Schema(
    leagueId: mongoose.Schema.Types.ObjectId,
    date: String,
    teams: Array
  )

  mongoose.model('simpletables', simpleTableSchema)