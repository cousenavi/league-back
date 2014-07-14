module.exports = (app) ->

  app.get '/tables/simple_table',  app.controllers.TablesController.getSimpleTable