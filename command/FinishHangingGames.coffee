process.env.NODE_ENV = 'dev'
config = require('./../config')
app = require('./../app')(config)

#app.models.Game.update({homeTeamScore: {$e: }})



app.models.Game.find({homeTeamScore: {$ne: null}, leagueId: '54009eb17336983c24342ed9', ended: false}, (e, m) ->
  for gm in m
    app.models.Game.findByIdAndUpdate(gm._id, {ended: true}, (e) -> console.log e)
)

