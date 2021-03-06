process.env.NODE_ENV = 'dev'
config = require('./../config')
app = require('./../app')(config)

app.models.Game.find( (err, models) ->
  app.models.Team.find( (err, teams) ->
    mappedTeams = {}
    for tm in teams
      mappedTeams[tm._id] = tm

    for gm in models
      app.models.Game.findByIdAndUpdate(gm._id, {
          homeTeamName: mappedTeams[gm.homeTeamId].name
          awayTeamName: mappedTeams[gm.awayTeamId].name
          homeTeamLogo: mappedTeams[gm.homeTeamId].logo
          awayTeamLogo: mappedTeams[gm.awayTeamId].logo
        }, (err, models) ->
        console.log err, models
      )
  )
)