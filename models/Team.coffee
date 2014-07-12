module.exports = ->
  mongoose = require 'mongoose'

  teamSchema = new mongoose.Schema(
    name: {type: String, index: {unique: true}}
    logo: String
    leagueName: String
    leagueId: mongoose.Schema.Types.ObjectId
  )
  mongoose.model('teams', teamSchema)