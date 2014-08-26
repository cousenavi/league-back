module.exports = (app) ->

  app.post '/login',          app.controllers.RefereeApi.login
  app.get '/matches',          app.controllers.RefereeApi.matches
  app.post '/logout',         app.controllers.RefereeApi.logout
  app.get '/game',         app.controllers.RefereeApi.game