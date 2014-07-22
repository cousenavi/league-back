module.exports = ->

  mongoose = require 'mongoose'

  climbingChartSchema = new mongoose.Schema(
    leagueId: mongoose.Schema.Types.ObjectId
    series: Array
  )

  mongoose.model('climbingcharts', climbingChartSchema)