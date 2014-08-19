process.env.NODE_ENV = 'dev'
config = require('./../config')
app = require('./../app')(config)

app.models.Game.find( (err, models) ->
  for gm in models
    dt = new Date(gm.datetime)

    dt.month = ->
      mth = @getMonth() + 1
      if mth < 10 then mth = '0'+mth
      mth
    dt.date  = ->
      date = @getDate()
      if date < 10 then date = '0'+date
    dt.year = ->
      @getYear() - 100

    date =  dt.getDate()+'/'+dt.month()+'/'+dt.year()
    app.models.Game.findByIdAndUpdate(gm._id, {date: date, time: null}, (err, models) ->
      console.log err, models
    )
#    app.models.Player.update(teamId: team._id, leagueId: team.leagueId, ->
#    )
)
