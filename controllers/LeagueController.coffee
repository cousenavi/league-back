class LeagueController extends require('./AbstractCrudController')
  model: (req) ->
    req.app.models.League

  getAll: (req, res) =>
    req.checkRootAccess()
    @model(req).find().sort(name: 'asc').exec((err, leagues) =>
      res.status(200)
      res.send(leagues)
    )


  add: (req, res) ->
    req.checkRootAccess()
    if !req.body._id?
      super req, res
    else
      @model(req).findByIdAndUpdate(req.body._id, req.body, =>  res.send 'ok')

  del: (req, res) =>
    req.checkRootAccess()
    super req, res

module.exports = new LeagueController()


