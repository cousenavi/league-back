module.exports = ->

  mongoose = require 'mongoose'

  leagueSchema = new mongoose.Schema(
    name:            String,
    logo:           String
  )

  mongoose.model('leagues', leagueSchema)