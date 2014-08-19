process.env.NODE_ENV = 'dev'
config = require('./../config')
app = require('./../app')(config)

app.models.Team.find( (err, models) ->
  for team in models

    app.models.Player.update({teamId: team._id}, {leagueId: team.leagueId}, {multi: true}, (err, models) ->
      console.log err, models
    )
#    app.models.Player.update(teamId: team._id, leagueId: team.leagueId, ->
#    )
)
