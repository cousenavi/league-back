process.env.NODE_ENV = 'dev'
config = require('./../config')
app = require('./../app')(config)

app.models.Game.find( (err, models) ->
  for gm in models
    app.models.Game.findByIdAndUpdate(gm._id, {homeTeamPlayers: [], awayTeamPlayers: []}, (err, models) ->
      console.log err, models
    )
#    app.models.Player.update(teamId: team._id, leagueId: team.leagueId, ->
#    )
)
