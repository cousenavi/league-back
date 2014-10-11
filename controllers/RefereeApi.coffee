class RefereeApi
  login: (req, res) =>
    req.app.models.Referee.findOne({login: req.body.login, password: req.body.password}, (err, model) =>
      if model
        req.session.ref = model
        @matches(req, res)
      else
        res.status(400)
        res.send 'Incorrect Login/Password'
    )

  ##
  # check if session is active
  sessionStatus: (req, res) =>
    res.send req.session? and req.session.ref?


  matches: (req, res) =>
    if !req.session.ref? or !req.session.ref._id?
      res.status(403).send('Access denied')
    else
      filter = {refereeId: req.session.ref._id+''}
      fields = {homeTeamPlayers: 0, awayTeamPlayers: 0}
      req.app.models.Game.find(filter, fields, (err, models) ->
        res.send models
      )

  game: (req, res) ->
    req.app.models.Game.findById(req.query._id, (err, game) ->
      if game
        if req.session.ref and game.refereeId+'' is  req.session.ref._id+''
          req.app.models.Player.find({teamId: game.homeTeamId}, (err, models) ->
            game.homeTeamPlayers = models
            req.app.models.Player.find({teamId: game.awayTeamId}, (err, models) ->
              game.awayTeamPlayers = models
              res.send game
            )
          )

        else
          res.status(403).send("access denied")
      else
        res.status(500)
    )

  save_game: (req, res) ->
    req.app.models.Game.findById(req.body._id, (err, game) ->
      if game
        if req.session.ref and game.refereeId+'' is  req.session.ref._id+''
            req.app.models.Game.findByIdAndUpdate(req.body._id, req.body, (err, model) ->
              if err
                console.log err
              res.send 'ok'
            )
        else
          res.status(403).send("access denied")
      else
        res.status(500).send('error')
    )

  logout: (req, res) ->
    res.send('ok')


module.exports = new RefereeApi()

