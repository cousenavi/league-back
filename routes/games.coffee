module.exports = (app) ->

  app.get '/games',             app.controllers.GameController.getAll
  app.get '/games/:id',         app.controllers.GameController.get
  app.post '/games/add',        app.controllers.GameController.add
  app.post '/games/del',        app.controllers.GameController.del