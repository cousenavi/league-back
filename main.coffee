require('zappa') ->
  @use 'bodyParser', @app.router, static: __dirname + '/public'

  mongoose = require('mongoose')
  mongoose.connect('mongodb://localhost/test')

  createModel = (modelName) ->
    schema = mongoose.Schema(require("./public/js/dto/#{modelName}.json"))
    mongoose.model(modelName, schema)

  Player = createModel('Player')
  Team   = createModel('Team')
  Game   = createModel('Game')

  @get '/': ->
    'league test'

  ### ----------- TEAMS ------------- ###

  @get '/teams' : ->
    Team.find((err, teams) => @send teams )

  @get '/teams/:name': ->

    Team.findOne(
      name: @params.name, (err, team) =>
        Player.find({team: team.name}, (err, players) =>
          @send {
            'team': team,
            'players': players
          }
        )
    )


  @post '/team_add' : ->
    (new Team(@request.body)).save(=> @send 'ok')

  @post '/team_update': ->
    Team.findByIdAndUpdate(@request.body._id, @request.body, => @send 'ok')

  @post '/team_delete' : ->
    Team.findByIdAndRemove(@request.body._id, => @send 'ok')


  ### ----------- Players ------------- ###

  @get '/players' : ->
    Player.find((err, players) => @send players)

  @post '/player_add' : ->
    (new Player(@request.body)).save(=> @send 'ok')

  @post '/player_update': ->
    Player.findByIdAndUpdate(@request.body._id, @request.body, => @send 'ok')

  @post '/player_delete' : ->
    Player.findByIdAndRemove(@request.body._id, => @send 'ok')

  ### ------------- Calendar -------------- ###

  @get '/games' : ->
    Game.find((err, games) => @send games)

  defineTeamsStatsChanges = (game, oldgame = null) ->
    #определяем, как изменить статистику у команды. Если уже сохраняли игру и теперь исправляем, передайте oldgame

    if game.homeScore > game.awayScore
      homePoints  = 3
      awayPoints  = 0
    else if game.homeScore = game.awayScore
      homePoints  = 1
      awayPoints  = 1
    else
      homePoints  = 0
      awayPoints  = 3

    if oldgame is null
      oldHomePoints = 0
      oldAwayPoints = 0
      oldGamesPlayed = 0
      oldHomeScore = 0
      oldAwayScore = 0
    else
      oldGamesPlayed = 1
      oldHomeScore = oldgame.homeScore
      oldAwayScore = oldgame.awayScore
      if oldgame.homeScore > oldgame.awayScore
        oldHomePoints  = 3
        oldAwayPoints  = 0
      else if oldgame.homeScore is oldgame.awayScore
        oldHomePoints  = 1
        oldAwayPoints  = 1
      else
        oldHomePoints  = 0
        oldAwayPoints  = 3

    homeTeam =
      points: homePoints - oldHomePoints
      gamesPlayed: 1 - oldGamesPlayed,
      goalsScored: game.homeScore - oldHomeScore,
      goalsConceded: game.awayScore - oldAwayScore
    awayTeam =
      points: awayPoints - oldAwayPoints,
      gamesPlayed: 1 - oldGamesPlayed,
      goalsScored: game.awayScore ,
      goalsConceded: game.homeScore

    return {homeTeam: homeTeam, awayTeam: awayTeam}

  @post '/game_add' : ->
    game = @request.body
    (new Game(game)).save(=> @send 'ok')
    if game.homeTeamScore
      diff = defineTeamsStatsChanges(game)
      home = diff.homeTeam
      away = diff.awayTeam
      Team.where({ name: game.homeTeam }).update({ $inc: {home}})
      Team.where({ name: game.awayTeam}).update({ $inc: {away}})

  @post '/game_update': ->
    Game.findByIdAndUpdate(@request.body._id, @request.body, => @send 'ok')

  @post '/game_delete': ->
    Game.findByIdAndRemove(@request.body._id, => @send 'ok')