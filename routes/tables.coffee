module.exports = (app) ->

  app.get '/tables/simple_table',    app.controllers.TablesController.getSimpleTable
  app.get '/tables/chess_table',     app.controllers.TablesController.getChessTable
  app.get '/tables/climbing_chart',  app.controllers.TablesController.getClimbingChart
  app.get '/tables/top_goalscorers', app.controllers.TablesController.getTopGoalscorers
  app.get '/tables/top_goalscorers', app.controllers.TablesController.getTopAssistants
  app.get '/tables/top_goalscorers', app.controllers.TablesController.getTopPoints
  app.get '/tables/top_goalscorers', app.controllers.TablesController.getTopStars