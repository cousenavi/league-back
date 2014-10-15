module.exports = ->

  mongoose = require 'mongoose'

  schema = new mongoose.Schema(
    leagueId: mongoose.Schema.Types.ObjectId
    leagueLogo: String
    leagueName: String

    played: {type: Number, default: 0}
    scored: {type: Number, default: 0}

    yellow: {type: Number, default: 0}
    red:    {type: Number, default: 0}

    topScoredTeams: Array
    lessConceededTeams: Array
    mostRudeTeams: Array

    topGoalscorers: Array
    topAssistants: Array

    winStrikes: Array
    loseStrikes: Array

    topWinStrikes: Array
    topLoseStrikes: Array

    records: mongoose.Schema.Types.Mixed
    formRecords: mongoose.Schema.Types.Mixed

  )

  mongoose.model('toursummary', schema)