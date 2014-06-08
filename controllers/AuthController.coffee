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
    require('./../models/User').find({}, {password: 0}, (err, users) ->
      res.send users
    )

  addUser: (req, res) ->
    req.requireRole('root')
    User = require('./../models/User')
    (new User(req.body)).save (err) =>
      if err then res.status(400).send(err) else res.send 'ok'

  updateUser: (req, res) ->
    req.requireRole('root')
    User = require('./../models/User')
    User.findByIdAndUpdate(req.body._id, req.body, (err) =>
      throw err if err?
      res.send 'ok'
    )

  deleteUser: (req, res) ->
    req.requireRole('root')
    User = require('./../models/User')
    User.findByIdAndRemove(req.body._id, (err) =>
      if err then res.status(500).send(err) else res.send 'ok'
    )