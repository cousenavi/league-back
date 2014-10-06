class View
  ##
  #
  constructor: (@registry) ->
    @$container = $('#container')

  ##
  #
  render: =>
    if !@registry.user.authorized
      @viewLogin()
    else
      @viewGamesList()

  ##
  #
  viewLogin: =>
    if @registry.user.authorized
      @registry.setUserStatus(false)
    @$container.html templates.login()

  ##
  #
  viewGamesList: =>
    if @registry.games is null
      @registry.loadGames => @viewLoadedGamesList()
    else
      @viewLoadedGamesList()

  ##
  #
  viewLoadedGamesList: =>
    @$container.html templates.games(@registry.games)

  ##
  #
  viewGame: (id) =>
    if !@registry.games[id].teams[0].players? or @registry.games[id].teams[0].players.length is 0
      @registry.loadGame(id, => @viewLoadedGame(id))
    else
      @viewLoadedGame(id)

  ##
  #
  viewLoadedGame: (id) =>
    @$container.html templates.game(@registry.games[id])

  ##
  # показываем протокол игры
  viewRoster: (gameId, side) =>
    teamIndex = if side is 'home' then 0 else 1
    team = @registry.games[gameId].teams[teamIndex]
    team.players.sort((a,b) ->
      if !a.played? then a.played = false
      if !b.played? then b.played = false

      if a.played > b.played then return -1
      if a.played < b.played then return 1

      if a.number < b.number then return -1
      if a.number > b.number then return 1
    )
    @$container.html templates.roster(gameId, side, team)

  ##
  # показываем протокол игры, перед этим его подгрузив
  actionLoadRoster: (gameId, side) =>
    @registry.loadGame gameId, => @viewRoster(gameId, side)

    ##
  #
  viewTeamChoise: (gameId, side) =>
    opponentPlayers = if side isnt 'home' then @registry.games[gameId].homeTeamPlayers else @registry.games[gameId].awayTeamPlayers

    @$container.html templates.choise(name, players)


  ##
  #
  actionLogin: (model) =>
    @registry.login model, =>
      @viewGamesList()

  actionLogout: (model) =>
    @registry.clean()
    @viewLogin()

  ##
  # загрузка списка игр с сервера
  actionLoadGames: =>
    @registry.loadGames =>
      @viewLoadedGamesList()

  ##
  # загрузка игры с сервера
  actionLoadGame: (id) =>
    @registry.loadGame id,  =>
      @viewLoadedGame(id)

  ##
  # нажатие "ок" после оформления протокола или выбора команд
  actionSetGameStats: (game) =>
    @registry.setGameStats(game)
    @viewLoadedGame(game._id)

  ##
  # изменяем статистический параметр у игрока
  actionSetPlayerStats: (gameId, side, playerId, field, value) =>
    teamIndex = if side is 'home' then 0 else 1
    @registry.saveRosterState(gameId, side)

    for pl in @registry.games[gameId].teams[teamIndex].players
      if pl._id is playerId
        if typeof value is 'object'
          if value.$inc?
            if !pl[field]? then pl[field] = value.$inc else pl[field] = pl[field] + value.$inc
        else
          pl[field] = value

    @registry.save()
    @$container.html templates.roster gameId, side, @registry.games[gameId].teams[teamIndex]

  actionUndo: (gameId, side) =>
    teamIndex = if side is 'home' then 0 else 1
    @registry.restoreRosterState(gameId, side)
    @$container.html templates.roster gameId, side, @registry.games[gameId].teams[teamIndex]

  ##
  # синхронизация игры с сервером
  actionSaveGame: (game) =>
    @registry.saveGame game, =>
      @viewGamesList()

  ##
  # завершаем и сохраняем игру
  actionEndGame: (id) =>
    game = @registry.games[id]
#    game.ended = true
    @registry.saveGame game, => @viewGamesList