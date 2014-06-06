module.exports = class TeamController

  getAll: (req, res) ->
    req.buildModel('Team').find((err, teams) => res.send teams )

  get: (req, res) ->
    req.buildModel('Team').findOne(
      name: req.params.name, (err, team) =>
        if !team
          res.status(404).send()
        else
          req.buildModel('Player').find({team: team.name}, (err, players) =>
            res.send {
              'team': team,
              'players': players
            }
          )
    )

  add: (req, res) ->
    Team = new req.buildModel('Team')
    (new Team(req.body)).save (err) =>
      if err then res.status(400).send(err) else res.send 'ok'

  update: (req, res) ->
    Team = new req.buildModel('Team')
    Team.findByIdAndUpdate(req.body._id, req.body, => res.send 'ok')

  delete : (req, res) ->
    Team = new req.buildModel('Team')
    Team.findByIdAndRemove(req.body._id, (err) =>
      if err then res.status(500).send(err) else res.send 'ok'
    )
