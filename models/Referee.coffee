module.exports = ->

  mongoose = require 'mongoose'

  refereeSchema = new mongoose.Schema(
    name:            String,
    photo:           String,
    serviced:        {type: Number, default: 0}
    rating:          {type: Number, default: 0}
    sortWeight:      Number # calculated field (@todo определить алгоритм)
  )

  mongoose.model('referees', refereeSchema)