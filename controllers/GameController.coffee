class GameController extends require('./AbstractCrudController')
  model: (req) ->
    req.app.models.Game

  getAll: (req, res) =>
    @model(req).find(req.query).sort(datetime: 'desc').find( (err, models) =>
      res.send models
    )

  add: (req, res) ->
    req.requireRole('admin')
    super req, res

  upd: (req, res) ->
    req.requireRole('admin')
    @model(req).findByIdAndUpdate(req.body._id, req.body,  =>
      res.send 'ok'
#      @model(req).findById(req.body._id, (err, model) =>
#        if req.body.homeTeamScore? then req.app.emit 'event:result_added', model
#      )
    )

  del: (req, res) =>
    req.requireRole('admin')
    super req, res

module.exports = new GameController()


