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
  #TODO вроде как депрекейтед, разобраться, как теперь парсить post

  app.all '/', (req, res, next) ->
    res.header("Access-Control-Allow-Origin", "*")
    res.header("Access-Control-Allow-Headers", "X-Requested-With")
    next()

  app.use (req, res, next) ->
    req.requireRole = (role) ->
      return true
      if req.session.user? && require('./roles/checkRole')(req.session.user.roles, role)
        return true
      else
        throw {code: 403, message: 'Access Denied'}
    next()

  load = require('express-load')
  load('models').then('controllers').then('routes').into(app)

  app.on 'event:result_added', app.controllers.TablesController.onResultAdded
  return app




