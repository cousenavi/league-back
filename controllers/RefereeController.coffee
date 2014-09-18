class RefereeController extends require('./AbstractCrudController')
  model: (req) ->
    req.app.models.Referee

  getAll: (req, res) =>
    req.checkHeadAccess()
    @model(req).find().sort(weight: 'desc').exec((err, refs) =>
      res.status(200)
      res.send(refs)
    )

  add: (req, res) ->
    req.checkHeadAccess()
    req.body.name = req.body.name.toUpperCase()
    if !req.body._id?
      super req, res
    else
      @model(req).findByIdAndUpdate(req.body._id, req.body, =>  res.send 'ok'  )

  del: (req, res) =>
    req.checkHeadAccess()
    super req, res

module.exports = new RefereeController()


