module.exports = ->

  mongoose = require 'mongoose'

  leagueSchema = new mongoose.Schema(
    leagueId: mongoose.Schema.Types.ObjectId
    teams: Array
  )

  mongoose.model('simpletables', leagueSchema)