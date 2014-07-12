module.exports = ->
  mongoose = require 'mongoose'

  placeSchema = new mongoose.Schema(
    name: {type: String, index: {unique: true}}
    address: String
  )
  mongoose.model('places', placeSchema)