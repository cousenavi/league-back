module.exports = (app) ->

  prefix = '/adminapi/'
  
  app.post prefix+'login',     app.controllers.AdminApi.login
  app.get  prefix+'logout',    app.controllers.AdminApi.logout
  app.post prefix+'sublogin',  app.controllers.AdminApi.subLogin

  app.get prefix+'info',       app.controllers.AdminApi.info

  app.get prefix+'users',      app.controllers.AdminApi.users
  app.get prefix+'heads',      app.controllers.AdminApi.heads
  app.post prefix+'add_user',  app.controllers.AdminApi.addUser
  app.post prefix+'del_user',  app.controllers.AdminApi.delUser