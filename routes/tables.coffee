module.exports = (app) ->

  app.get '/tables/simple_table',   app.controllers.TablesController.getSimpleTable
  app.get '/tables/chess_table',    app.controllers.TablesController.getChessTable
  app.get '/tables/climbing_chart', app.controllers.TablesController.getClimbingChart