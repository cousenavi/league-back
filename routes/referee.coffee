module.exports = (app) ->

  app.get '/referees',      app.controllers.RefereeController.getAll
  app.get '/referees/:id',  app.controllers.RefereeController.get
  app.post '/referees/add', app.controllers.RefereeController.add
  app.post '/referees/del', app.controllers.RefereeController.del