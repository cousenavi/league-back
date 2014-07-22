module.exports = ->

  mongoose = require 'mongoose'

  simpleTableSchema = new mongoose.Schema(
    leagueId: mongoose.Schema.Types.ObjectId
    teams: Array
  )

  mongoose.model('simpletables', simpleTableSchema)