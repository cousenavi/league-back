module.exports = class AbstractCrudController
  getAll: (req, res) =>
    @model(req).find(req.query, (err, models) =>
      res.send models
    )

  get: (req, res) ->
#    @model(req).findById(req.params._id, (err, model) ->
#      if err
#        console.log err
#        throw err
#      if !model
#        res.status(404).send()
#        return
#
#      return model
#    )

  add: (req, res) =>
    Model = @model(req)
    (new Model(req.body)).save (err, model) =>
      if err
        res.status(400).send(err)
      else
        res.status(200)
        res.send {_id: model._id}

  upd: (req, res) =>
    @model(req).findByIdAndUpdate(req.body._id, req.body, =>  res.send 'ok'  )

  del : (req, res) ->
    @model(req).findByIdAndRemove(req.body._id, (err) =>
      if err then res.status(500).send(err) else res.send 'ok'
    )