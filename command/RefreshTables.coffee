process.env.NODE_ENV = 'dev'
config = require('./../config')
app = require('./../app')(config)

#app.models.League.find( (err, models) ->
#  for model in models
#    app.emit 'event:result_added', {leagueId: model._id}
#)

app.emit 'event:result_added', {leagueId: '54009eb17336983c24342ed9'}