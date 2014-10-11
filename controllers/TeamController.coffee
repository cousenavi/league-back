class TeamController extends require('./AbstractCrudController')
  model: (req) ->
    req.app.models.Team

  getAll: (req, res) ->
    req.checkAccessToLeague(req.query.leagueId)
    filter = if req.query.leagueId? then {leagueId: req.query.leagueId} else {} #todo временное решение для старого интерфейса. Убрать

    @model(req).find(, (err, models) ->
      res.send models
    )

  add: (req, res) ->
    req.checkAccessToLeague(req.body.leagueId)
    if !req.body._id?
      super req, res
    else
      @model(req).findByIdAndUpdate(req.body._id, req.body, =>  res.send 'ok'  )


  upd: (req, res) ->
    req.checkAccessToLeague(req.body.leagueId)
    super req, res

  del: (req, res) =>
    req.app.models.Team.findById(req.body._id, (err, team) =>
      req.checkAccessToLeague(team.leagueId)
      super req, res
    )

module.exports = new TeamController()


