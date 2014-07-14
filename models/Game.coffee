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
    tour:         Number
  )
  mongoose.model('games', gameSchema)