module.exports = class TeamController

  getAll: (req, res) ->
    require('./../models/Team').find((err, teams) => res.send teams )

  get: (req, res) ->
    require('./../models/Team').findOne(
      name: req.params.name, (err, team) =>
        if !team
          res.status(404).send()
        else
          require('./../models/Player').find({team: team.name}, (err, players) =>
            res.send {
              'team': team,
              'players': players
            }
          )
    )

  add: (req, res) ->
    Team = require('./../models/Team')
    (new Team(req.body)).save (err) =>
      if err then res.status(400).send(err) else res.send 'ok'

  update: (req, res) ->
    Team = require('./../models/Team')
    Team.findByIdAndUpdate(req.body._id, req.body, => res.send 'ok')

  delete : (req, res) ->
    Team = require('./../models/Team')
    Team.findByIdAndRemove(req.body._id, (err) =>
      if err then res.status(500).send(err) else res.send 'ok'
    )
