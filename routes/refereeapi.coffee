module.exports = (app) ->

  prefix = '/refereeapi/'
  
  app.post prefix+'login',           app.controllers.RefereeApi.login
  app.post prefix+'logout',          app.controllers.RefereeApi.logout
  app.get  prefix+'session_status', app.controllers.RefereeApi.sessionStatus
  
  app.get prefix+'games',            app.controllers.RefereeApi.matches
  app.get prefix+'game',             app.controllers.RefereeApi.game
  app.post prefix+'save_game',       app.controllers.RefereeApi.save_game