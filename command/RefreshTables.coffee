process.env.NODE_ENV = 'dev'
config = require('./../config')
app = require('./../app')(config)

app.models.League.find( (err, models) ->
  for model in models
    app.emit 'event:result_added', {leagueId: model._id}
)
