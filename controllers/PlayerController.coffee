class PlayerController extends require('./AbstractCrudController')
  getAll: (req, res) =>
    if req.checkAccessToTeam(req.query.teamId)
      @model(req).find(req.query, (err, models) =>
        res.send models
      )

  model: (req) ->
    req.app.models.Player

  add: (req, res) =>
    if req.checkAccessToTeam(req.body.teamId)
      req.body.name = req.body.name.toUpperCase()
      if req.body._id?
        @upd(req, res)
      else
        super req, res

  upd: (req, res) ->
    super req, res

  del: (req, res) =>
    req.app.models.Player.findById(req.body._id, (err, player) =>
      if req.checkAccessToTeam(player.teamId)
        super req, res
    )



module.exports = new PlayerController()


