process.env.NODE_ENV = 'dev'
config = require('./../config')
app = require('./../app')(config)

app.models.Team.findOneAndUpdate({name: 'Sporting-1'}, {name: 'Sporting'}, (err, model) ->
  console.log model
)