module.exports = ->

  mongoose = require 'mongoose'

  schema = new mongoose.Schema(
    leagueId: mongoose.Schema.Types.ObjectId
    players: Array
  )

  mongoose.model('topassistants', schema)