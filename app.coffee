module.exports = (config) ->
  express = require 'express'
  app = express()

  app.use(express.static(__dirname + '/public'));

  cookieParser = require('cookie-parser')
  session      = require('express-session')




  app.mongoose = require('mongoose').connect(config.db)

  app.use cookieParser('omg_so_secret!')
  app.use session()

  bodyParser = require 'body-parser'
  app.use bodyParser()

  app.use (req, res, next) ->
    req.buildModel = (modelName) ->
      #@TODO посмотреть, может хранить compiledModels не нужно и есть нативный метод у mongoose
      app.compiledModels = [] if not app.compiledModels
      if app.compiledModels[modelName] then return app.compiledModels[modelName] else
        schema = app.mongoose.Schema(require("./public/js/dto/#{modelName}.json"))
        model = app.mongoose.model(modelName, schema)
        app.compiledModels[modelName] = model
        return model

    next()

  require('./router').initRoutes(app)

  return app
