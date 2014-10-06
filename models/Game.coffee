module.exports = ->
  mongoose = require 'mongoose'

  gameSchema = new mongoose.Schema(
    homeTeamId:   mongoose.Schema.Types.ObjectId
    homeTeamName: String
    homeTeamLogo: String

    awayTeamId:   mongoose.Schema.Types.ObjectId
    awayTeamName: String
    awayTeamLogo: String

    homeTeamScore: Number
    awayTeamScore: Number

    homeTeamRefereeMark: Number
    awayTeamRefereeMark: Number

    homeTeamPlayers: Array
    awayTeamPlayers: Array

    datetime: Date
    date: String
    time: String

    placeId:      {type: mongoose.Schema.Types.ObjectId, null: true}
    placeName:    String

    refereeId:    {type: mongoose.Schema.Types.ObjectId, null: true}
    refereeName:  String

    leagueId:     mongoose.Schema.Types.ObjectId
    tourNumber:         Number

    ended: {type: Boolean, default: false}
  )
  mongoose.model('games', gameSchema)