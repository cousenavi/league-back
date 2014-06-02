express = require 'express'
app = express()

bodyParser = require 'body-parser'

cookieParser = require('cookie-parser')
session      = require('express-session')

mongoose = require 'mongoose'
db = mongoose.connect('mongodb://localhost/test')

app.use cookieParser('omg_so_secret!')
app.use session()
app.use bodyParser()

app.use (req, res, next) ->
  req.buildModel = (modelName) ->
    #@TODO посмотреть, может хранить compiledModels не нужно и есть нативный метод у mongoose
    app.compiledModels = [] if not app.compiledModels
    if app.compiledModels[modelName] then return app.compiledModels[modelName] else
      schema = mongoose.Schema(require("./public/js/dto/#{modelName}.json"))
      model = mongoose.model(modelName, schema)
      app.compiledModels[modelName] = model
      return model

  next()

require('./router').initRoutes(app)

server = app.listen(3000, ->
  console.log 'server started'
)