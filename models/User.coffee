module.exports = ->

  mongoose = require 'mongoose'

  schema = new mongoose.Schema(
    login: String
    password: String

    role: String # root|head|captain
    leagueId:      {type: mongoose.Schema.Types.ObjectId, null: true}
    teamId:        {type: mongoose.Schema.Types.ObjectId, null: true}
  )

  mongoose.model('users', schema)