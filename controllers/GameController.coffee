class GameController extends require('./AbstractCrudController')
  model: (req) ->
    req.app.models.Game

  get: (req, res) =>
    @model(req).findById(req.params.id, (err, model) ->
      res.send model
    )

  getAll: (req, res) =>
#    if req.query.leagueId?
#      req.checkAccessToLeague(req.query.leagueId)
#    else if req.query.teamId?
#      req.checkAccessToTeam(req.query.teamId)
#    else
#      res.status(403).send('access denied')
     #TODO TEMPORARY DISABLED

    if req.query.startDate?
      startDate = req.query.startDate
      delete req.query.startDate
    if req.query.endDate?
      endDate = req.query.endDate
      delete req.query.endDate

    filter = req.query
    filter.datetime = {} if startDate? or endDate?
    filter.datetime.$gte = startDate if startDate?
    filter.datetime.$lte = endDate if endDate?
    if filter.teamId?
      filter.$or = [{homeTeamId: teamId}, {awayTeamId: teamId} ]
      delete filter.teamId

    if req.query.showPlayers?
      fields = {}
      delete req.query.showPlayers
    else
      fields = {homeTeamPlayers: 0, awayTeamPlayers: 0}

    @model(req).find(filter, fields).sort(datetime: 'desc').find( (err, models) =>
      res.send models
    )

  formatDatetime = (date, time) ->
    dt = date.split('/')
    tm = (if time? and time isnt '' then time.split(':') else ['0', '0'])
    return new Date(dt[1]+'/'+dt[0]+'/'+dt[2]+' '+tm['0']+':'+tm[1])

  add: (req, res) ->
    req.checkAccessToLeague(req.body.leagueId)

    req.body.refereeId = null if req.body.refereeId is ''
    req.body.datetime = formatDatetime(req.body.date, req.body.time)

    Model = @model(req)

    if req.body._id?  #updating
      @model(req).findByIdAndUpdate(req.body._id, req.body,  =>
        res.send 'ok'
        @model(req).findById(req.body._id, (err, model) =>
          if req.body.homeTeamScore? then req.app.emit 'event:result_added', model
        )
      )
    else #adding
      (new Model(req.body)).save (err, model) =>
        if err
          res.status(400).send(err)
        else
          res.status(200)
          res.send {_id: model._id}
          @model(req).findById(model._id, (err, model) =>
            if req.body.homeTeamScore? then req.app.emit 'event:result_added', model
          )

  del: (req, res) =>
    req.app.models.Game.findById(req.body._id, (err, game) =>
      if game.homeTeamScore? then req.checkRootAccess() else req.checkAccessToLeague(game.leagueId)
      super req, res
    )


module.exports = new GameController()


