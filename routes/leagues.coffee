module.exports = (app) ->

  app.get '/leagues',      app.controllers.LeagueController.getAll
  app.get '/leagues/:id',  app.controllers.LeagueController.get
  app.post '/leagues/add', app.controllers.LeagueController.add
  app.post '/leagues/upd', app.controllers.LeagueController.upd
  app.post '/leagues/del', app.controllers.LeagueController.del