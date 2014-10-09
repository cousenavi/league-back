module.exports = (app) ->

  app.post '/refereeapi/login',          app.controllers.RefereeApi.login
  app.get '/refereeapi/games',          app.controllers.RefereeApi.matches
  app.post '/refereeapi/logout',         app.controllers.RefereeApi.logout
  app.get '/refereeapi/game',         app.controllers.RefereeApi.game
  app.post '/refereeapi/save_game',         app.controllers.RefereeApi.save_game