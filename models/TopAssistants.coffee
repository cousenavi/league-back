module.exports = ->

  mongoose = require 'mongoose'

  schema = new mongoose.Schema(
    leagueId: mongoose.Schema.Types.ObjectId
    teams: Array
  )

  mongoose.model('topassistants', schema)