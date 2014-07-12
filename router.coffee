##@TODO раскурить autoloading
#
#TeamController = require './controllers/TeamController'
#teamController = new TeamController()
#AuthController = require './controllers/AuthController'
#authController = new AuthController()
#PlayerController = require './controllers/PlayerController'
#playerController = new PlayerController()
#
#PlaceController = require './controllers/PlaceController'
#placeController = new PlaceController()
#
#RefereeController = require './controllers/RefereeController'
#refereeController = new RefereeController
#
##GameController   = require('./controllers/GameController')
#
#initRoutes = (app) ->
#
#  ###             auth                 ###
#  app.post '/login', (req, res) ->
#    authController.login(req, res)
#
#  app.get '/logout', (req, res) ->
#    authController.logout(req, res)
#
#    #TODO подумать, как регистрировать CRUD роуты
#
#
#  app.get '/users', (req, res) ->
#    authController.getAll(req, res)
#
#  app.post '/users_add', (req, res) ->
#    authController.addUser(req, res)
#
#  app.post '/users_update', (req, res) ->
#    authController.updateUser(req, res)
#
#  app.post '/users_delete', (req, res) ->
#    authController.deleteUser(req, res)
#
#
#  ###             teams                ###
#  app.get '/teams', (req, res) ->
#    teamController.getAll(req, res)
#
#  app.get '/teams/:name', (req, res) ->
#    teamController.get(req, res)
#
#  app.post '/teams_add', (req, res) ->
#    teamController.add(req, res)
#
#  app.post '/teams_update', (req, res) ->
#    teamController.update(req, res)
#
#  app.post '/teams_delete', (req, res) ->
#    teamController.delete(req, res)
#
#  ###             players                ###
#  app.get '/players', (req, res) ->
#    playerController.getAll(req, res)
#
#
#  ###             games                ###
#
#
#  ###             referees             ###
##  app.get '/referees', (req, res) ->
##    refereeController.getAll(req, res)
##
##  app.get '/referees/:name', (req, res) ->
##    refereeController.get(req, res)
##
##  app.post '/referees_add', (req, res) ->
##    refereeController.add(req, res)
##
##  app.post '/referees_update', (req, res) ->
##    refereeController.update(req, res)
##
##  app.post '/referees_delete', (req, res) ->
##    refereeController.delete(req, res)
#
#
#  ###             places               ###
#
#
#  app.get '/places', (req, res) ->
#    placeController.getAll(req, res)
#
#  app.get '/places/:name', (req, res) ->
#    placeController.get(req, res)
#
#  app.post '/places_add', (req, res) ->
#    placeController.add(req, res)
#
#  app.post '/places_update', (req, res) ->
#    placeController.update(req, res)
#
#  app.post '/places_delete', (req, res) ->
#    placeController.delete(req, res)
#
#
#
#exports.initRoutes = initRoutes