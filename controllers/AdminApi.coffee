class RefereeApi

  #
  #
  #
  login: (req, res) =>
    req.app.models.User.findOne(
      {login:req.body.login, password: req.body.password},
      {password: 0},
      (err, model) ->
        if model
          req.session.user = model
          res.send model
        else
          res.status(400)
          res.send 'Incorrect Login/Password'
    )

  #
  #
  #
  info: (req, res) =>
    req.checkHeadAccess()
    res.send {}

  #
  #
  #
  users: (req, res) =>
    req.checkRootAccess()
    req.app.models.User.find({}, (err, models) ->
        res.send models
    )

  #
  #
  #
  addUser: (req, res) =>
    req.checkRootAccess()

    if req.body._id
      req.app.models.User.findByIdAndUpdate(req.body._id, req.body, (err, model) =>
        if err
          res.status(400).send(err)
        else
          res.send {_id: model._id}
      )
    else
      (new req.app.models.User(req.body)).save((err, model) ->
        if err
          res.status(400).send(err)
        else
          res.send {_id: model._id}
      )

  #
  #
  #
  delUser: (req, res) =>
    req.checkRootAccess()
    req.app.models.User.findByIdAndRemove(req.body._id, (err) =>
      if err then res.status(500).send(err) else res.send 'ok'
    )

module.exports = new RefereeApi()

