module.exports = (app) ->

  app.post '/login',          app.controllers.RefereeApi.login
  app.post '/logout',         app.controllers.RefereeApi.logout
  app.get '/game',         app.controllers.RefereeApi.game