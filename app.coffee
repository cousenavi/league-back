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

    req.requireRole = (role) ->
      return true
      if req.session.user? && require('./roles/checkRole')(req.session.user.roles, role)
        return true
      else
        res.status(403).send()
    next()

  app.use (req, res, next) ->
    req.buildModel = (modelName) ->
     return require "./models/#{modelName}"

    next()

  require('./router').initRoutes(app)

  return app