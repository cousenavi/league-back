class PlaceController extends require('./AbstractCrudController')
  model: (req) ->
    req.app.models.Place

  add: (req, res) ->
    req.checkRootAccess()
    super req, res

  upd: (req, res) ->
    req.checkRootAccess()
    super req, res

  del: (req, res) =>
    req.checkRootAccess()
    super req, res

module.exports = new PlaceController()


