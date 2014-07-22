module.exports = ->

  mongoose = require 'mongoose'

  chessTableSchema = new mongoose.Schema(
    leagueId: mongoose.Schema.Types.ObjectId
    teams: Array
  )

  mongoose.model('chesstables', chessTableSchema)