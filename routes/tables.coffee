module.exports = (app) ->

  app.get '/tables/simple_table',      app.controllers.TablesController.getSimpleTable
  app.get '/tables/simple_table_keys', app.controllers.TablesController.getSimpleTableKeys


  app.get '/tables/chess_table',       app.controllers.TablesController.getChessTable
  app.get '/tables/climbing_chart',    app.controllers.TablesController.getClimbingChart
  app.get '/tables/top_players',       app.controllers.TablesController.getTopPlayers
  app.get '/tables/best_players',      app.controllers.TablesController.getBestPlayers
  app.get '/tables/tour_summary',      app.controllers.TablesController.getTourSummary
  app.get '/tables/game_preview',      app.controllers.TablesController.getGamePreview