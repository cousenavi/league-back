module.exports =

class AuthController

  login: (req, res) ->
    require('./../models/User').findOne({email: req.body.email, password: req.body.password}, (err, user) ->
      if !user
        res.status(400).send()
      else
        req.session.user = user
        res.send roles: user.roles
    )

  logout: (req, res) ->
    res.send 'logout'


  getAll: (req, res) ->
    req.requireRole('root')
    require('./../models/User').find((err, users) ->
      res.send users
    )

  addUser: (req, res) ->
    res.send 'add user'

  updateUser: (req, res) ->
    res.send 'edit user'

  deleteUser: (req, res) ->
    res.send 'delete user'