class LeagueController extends require('./AbstractCrudController')
  model: (req) ->
    req.app.models.League


  add: (req, res) ->
    req.requireRole('admin')
    super req, res

  upd: (req, res) ->
    req.requireRole('admin')
    super req, res

  del: (req, res) =>
    req.requireRole('admin')
    super req, res

module.exports = new LeagueController()


