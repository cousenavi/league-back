class RefereeApi

  ##
  # залогиниваем юзера
  login: (req, res) =>
    req.app.models.User.findOne(
      {login:req.body.login, password: req.body.password},
      {password: 0},
      (err, user) ->
        if user
          req.session.user = {current: user, previous: null}
          res.send user
        else
          res.status(400)
          res.send 'Incorrect Login/Password'
    )

  ##
  # входим под более слабой ролью
  subLogin: (req, res) =>
    req.app.models.User.findById(req.body._id, {password: 0}, (err, user) ->
      if !user or !req.session.user?
        res.status(403).send('Access Denied')
      else
        if user.role is 'Head'
          req.checkRootAccess()
        else if user.role.is 'Captain'
          req.checkAccessToLeague(user.leagueId)
        else
          res.status(403)
          res.send 'Access Denied'
          throw new Error(403) #todo почему же нельзя сразу кидать 403, и в перехватчике уже сетить респонс?

        req.session.user = {current: user, previous: req.session.user}
        res.send user
    )

  ##
  # выходим из роли. Возвращаемся в предыдущую или вообще скидываем всё
  logout: (req, res) =>
    if !req.session.user?
      res.status 200
      res.send null
    else
      req.session.user = req.session.user.previous
      if req.session.user? then res.send req.session.user.current else res.send null


  ##
  # todo переписать
  # сейчас метод проверяет, что мы залогинены, но как-то странно
  info: (req, res) =>
    req.checkHeadAccess()
    res.send {}



  ##
  # @deprecated
  # список юзеров
  users: (req, res) =>
    req.checkRootAccess()
    req.app.models.User.find({}, (err, models) ->
        res.send models
    )

  ##
  # возвращаем список глав лиг
  heads: (req, res) =>
    req.checkRootAccess()
    req.app.models.User.find({role: 'Head'}, (err, models) ->
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

