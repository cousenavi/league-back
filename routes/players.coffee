module.exports = (app) ->

  app.get '/players',      app.controllers.PlayerController.getAll
  app.get '/players/:id',  app.controllers.PlayerController.get
  app.post '/players/add', app.controllers.PlayerController.add
  app.post '/players/del', app.controllers.PlayerController.del