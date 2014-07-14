class GameController extends require('./AbstractCrudController')
  model: (req) ->
    req.app.models.Game

  add: (req, res) ->
    req.requireRole('admin')
    super req, res

  upd: (req, res) ->
    req.requireRole('admin')
    @model(req).findByIdAndUpdate(req.body._id, req.body, (model) =>
       console.log model
       if req.body.homeTeamScore? then req.app.emit 'event:result_added', model
    )

  del: (req, res) =>
    req.requireRole('admin')
    super req, res

module.exports = new GameController()


