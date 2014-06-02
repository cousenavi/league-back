module.exports = class TeamController

  getAll: (req, res) ->
    req.buildModel('Team').find((err, teams) => res.send teams )

  get: (req, res) ->
    req.buildModel('Team').findOne(
      name: req.params.name, (err, team) =>
        req.buildModel('Player').find({team: team.name}, (err, players) =>
          res.send {
            'team': team,
            'players': players
          }
        )
    )
