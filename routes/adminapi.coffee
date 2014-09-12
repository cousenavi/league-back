module.exports = (app) ->

  app.post '/adminapi/login',  app.controllers.AdminApi.login
  app.get '/adminapi/info',  app.controllers.AdminApi.info
  app.get '/adminapi/users',  app.controllers.AdminApi.users
  app.post '/adminapi/add_user',  app.controllers.AdminApi.addUser
  app.post '/adminapi/del_user',  app.controllers.AdminApi.delUser