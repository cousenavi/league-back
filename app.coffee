module.exports = (config) ->
  express = require 'express'
  app = express()

  app.use(express.static(__dirname + '/public', {maxAge: 300}));

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
    req.checkRootAccess = ->
      if req.session.user? && req.session.user.current.role is 'root'
        return true
      res.status(403).send('Access denied').end()
      throw new Error(403)
    req.checkHeadAccess = ->
      if req.session.user? && (req.session.user.current.role is 'root' or req.session.user.current.role is 'Head')
        return true
      res.status(403).send('Access denied')
      throw new Error(403)
    req.checkAccessToLeague = (leagueId) ->
      if req.session.user?
        if req.session.user.current.role is 'root'
          return true
        else if req.session.user.current.role is 'Head' and req.session.user.current.leagueId+'' is leagueId+''
          return true
      res.status(403).send('Access denied')
      throw new Error(403)

    req.checkAccessToTeam = (teamId) ->
      if req.session.user?
        if req.session.user.current.role is 'root'
          return true
        else
          req.app.models.Team.findById(teamId, (err, team) ->

            if req.session.user.current.role is 'Head' and req.session.user.current.leagueId is team.leagueId
              return true
            else if req.session.user.current.role is 'Captain' and req.session.user.current.teamId is team._id+''
              return true
            else
              res.status(403).send('Access denied').end()
              throw new Error(403)
          )
      else
        res.status(403).send('Access denied').end()
        throw new Error(403)
    next()


  #todo этот перехватчик не работает!! Разобраться, кто собирает все ошибки
  app.use (err, req, res, next) ->
     console.log 'caught', err
     next()

  load = require('express-load')
  load('models').then('controllers').then('routes').into(app)

#  todo бред какой-то. Нельзя нормально получить доступ к объекту?
  app.controllers.TablesController.app = app

  StatsCompiler = require './tools/StatsCompiler.coffee'
  GameAdapter   = require './tools/GameAdapter.coffee'
  statsCompiler = new StatsCompiler(app, new GameAdapter())

  app.on 'event:result_added', statsCompiler.onResultAdded
  app.on 'event:result_added', app.controllers.TablesController.onResultAdded
  return app




