module.exports = class GameController
  _requireModel = ->
    require('./../models/Game')

  add: (req, res) ->
    req.requireRole('admin')
    Game = _requireModel()
    (new Game(req.body)).save (err, game) =>
      if err then res.status(400).send(err) else res.send {_id: game._id}

  addEvent:

  update: (req, res) ->
    @_requireModel().findById(
      req.body._id, (err, game) ->
        if game.refereeId? then req.requireRole('REFEREE_'+game.refereeId) else req.requireRole('admin')
        @_requireModel().update({_id: req.body._id}, req.body, ->
          res.send {_id: req.body._id}
        )
    )

  delete : (req, res) ->
    req.requireRole('admin')
    @_requireModel().findByIdAndRemove(req.body._id, (err) =>
      if err then res.status(500).send(err) else res.send 'ok'
    )
