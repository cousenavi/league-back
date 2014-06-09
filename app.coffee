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
      if req.session.user? && require('./roles/checkRole')(req.session.user.roles, role)
        return true
      else
        throw {code: 403, message: 'Access Denied'}
    next()


  require('./router').initRoutes(app)

  app.use (err, req, res, next)  ->
    if err.code?
      res.status(err.code).send(err.message)
    else
      throw err
  return app
