class RefereeController extends require('./AbstractCrudController')
  model: (req) ->
    req.app.models.Referee

  getAll: (req, res) =>
    @model(req).find().sort(weight: 'desc').exec((err, refs) =>
      res.status(200)
      res.send(refs)
    )

  add: (req, res) ->
    req.requireRole('admin')
    super req, res

  upd: (req, res) ->
    req.requireRole('admin')
    super req, res

  del: (req, res) =>
    req.requireRole('admin')
    super req, res

module.exports = new RefereeController()


