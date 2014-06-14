TeamController = require './controllers/TeamController'
teamController = new TeamController()
AuthController = require './controllers/AuthController'
authController = new AuthController()
PlayerController = require './controllers/PlayerController'
playerController = new PlayerController()

#GameController   = require('./controllers/GameController')

initRoutes = (app) ->

  ###             auth                 ###
  app.post '/login', (req, res) ->
    authController.login(req, res)

  app.get '/logout', (req, res) ->
    authController.logout(req, res)

  app.get '/users', (req, res) ->
    authController.getAll(req, res)

  app.post '/users_add', (req, res) ->
    authController.addUser(req, res)

  app.post '/users_update', (req, res) ->
    authController.updateUser(req, res)

  app.post '/users_delete', (req, res) ->
    authController.deleteUser(req, res)


  ###             teams                ###
  app.get '/teams', (req, res) ->
    teamController.getAll(req, res)

  app.get '/teams/:name', (req, res) ->
    teamController.get(req, res)

  app.post '/teams_add', (req, res) ->
    teamController.add(req, res)

  app.post '/teams_update', (req, res) ->
    teamController.update(req, res)

  app.post '/teams_delete', (req, res) ->
    teamController.delete(req, res)

  ###             players                ###
  app.get '/players', (req, res) ->
    playerController.getAll(req, res)


  ###             games                ###


exports.initRoutes = initRoutes