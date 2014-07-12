module.exports = (app) ->

  app.get '/teams',      app.controllers.TeamController.getAll
  app.get '/teams/:id',  app.controllers.TeamController.get
  app.post '/teams/add', app.controllers.TeamController.add
  app.post '/teams/upd', app.controllers.TeamController.upd
  app.post '/teams/del', app.controllers.TeamController.del