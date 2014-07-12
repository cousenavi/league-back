module.exports = (app) ->

  app.get '/places',      app.controllers.PlaceController.getAll
  app.get '/places/:id',  app.controllers.PlaceController.get
  app.post '/places/add', app.controllers.PlaceController.add
  app.post '/places/upd', app.controllers.PlaceController.upd
  app.post '/places/del', app.controllers.PlaceController.del