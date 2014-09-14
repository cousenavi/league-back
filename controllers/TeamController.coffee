class TeamController extends require('./AbstractCrudController')
  model: (req) ->
    req.app.models.Team

  add: (req, res) ->
    req.checkRootAccess()
    super req, res

  upd: (req, res) ->
    req.checkRootAccess()
    super req, res

  del: (req, res) =>
    req.checkRootAccess()
    super req, res

module.exports = new TeamController()


