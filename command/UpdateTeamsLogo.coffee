process.env.NODE_ENV = 'dev'
config = require('./../config')
app = require('./../app')(config)



app.models.Team.find( (err, teams) =>
  for team in teams
    team.logo = team.logo.replace(new RegExp('blocks'), 'leagues');
    app.models.Team.findByIdAndUpdate(team._id  , {logo: team.logo}, (err, model) ->
      console.log err, model
    )
)