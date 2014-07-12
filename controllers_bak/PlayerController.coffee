module.exports = class PlayerController
  _requireModel = ->
    require('./../models/Player')


  getAll: (req, res) ->
    _requireModel().find((err, teams) =>
      res.send teams
    )

  add: (req, res) ->
    req.requireRole('TEAM_'+res.body.team)
    Team = _requireModel()
    (new Team(req.body)).save (err, team) =>
      if err then res.status(400).send(err) else res.send {_id: team._id}