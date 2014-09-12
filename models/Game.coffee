module.exports = ->
  mongoose = require 'mongoose'

  gameSchema = new mongoose.Schema(
    homeTeamId:   mongoose.Schema.Types.ObjectId
    homeTeamName: String
    homeTeamLogo: String

    awayTeamId:   mongoose.Schema.Types.ObjectId
    awayTeamName: String
    awayTeamLogo: String

    datetime: Date
    date: String
    time: String


    placeId:      mongoose.Schema.Types.ObjectId
    placeName:    String

    refereeId:    {type: mongoose.Schema.Types.ObjectId, null: true}
    refereeName:  String

    homeTeamScore: Number
    awayTeamScore: Number

    leagueId:     mongoose.Schema.Types.ObjectId
    tourNumber:         Number

    homeTeamPlayers: Array
    awayTeamPlayers: Array

    ended: Boolean
  )
  mongoose.model('games', gameSchema)