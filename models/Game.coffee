module.exports = ->
  mongoose = require 'mongoose'

  gameSchema = new mongoose.Schema(
    homeTeamId:   mongoose.Schema.Types.ObjectId
    homeTeamName: String
    awayTeamId:   mongoose.Schema.Types.ObjectId
    awayTeamName: String

    datetime: Date
    placeId:      mongoose.Schema.Types.ObjectId
    placeName:    String

    refereeId:    mongoose.Schema.Types.ObjectId
    refereeName:  String

    homeTeamScore: Number
    awayTeamScore: Number

    leagueId:     mongoose.Schema.Types.ObjectId
    tourNumber:         Number

    homeTeamPlayers: Array
    awayTeamPlayers: Array
  )
  mongoose.model('games', gameSchema)