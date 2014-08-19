module.exports = ->

  mongoose = require 'mongoose'

  schema = new mongoose.Schema(
    leagueId: mongoose.Schema.Types.ObjectId
    tourNumber: Number
    players: Array
  )

  mongoose.model('bestplayers', schema)