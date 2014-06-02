TeamController = require './controllers/TeamController'
teamController = new TeamController()
AuthController = require './controllers/AuthController'
authController = new AuthController()

#GameController   = require('./controllers/GameController')
#PlayerController = require('./controllers/PlayerController')


initRoutes = (app) ->

  ###             auth                 ###
  app.post '/login', (req, res) ->
    authController.login(req, res)

  app.get '/logout', (req, res) ->
    authController.logout(req, res)

  app.post '/add_user', (req, res) ->
    authController.addUser(req, res)

  app.post '/edit_user', (req, res) ->
    authController.updateUser(req, res)

  app.post '/delete_user', (req, res) ->
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
    teamController.update(req, res)

  ###             players                ###
  ###             games                ###


exports.initRoutes = initRoutes