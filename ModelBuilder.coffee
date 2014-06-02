mongoose = require('mongoose')
mongoose.connect('mongodb://localhost/test')

class ModelBuilder
  build: (modelName) ->
    schema = mongoose.Schema(require("./public/js/dto/#{modelName}.json"))
    mongoose.model(modelName, schema)

module.exports = ModelBuilder