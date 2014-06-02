module.exports =

class AuthController

  login: (req, res) ->
    res.send 'login'

  logout: (req, res) ->
    res.send 'logout'

  addUser: (req, res) ->
    res.send 'add user'

  updateUser: (req, res) ->
    res.send 'edit user'

  deleteUser: (req, res) ->
    res.send 'delete user'