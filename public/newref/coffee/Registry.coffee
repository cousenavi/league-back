##
# Глобальная модель
class Registry

  ##
  #
  games: null
  user: {authorized: false}

  request: (options) =>
    prefix = '/refereeapi/'
    redirectUrl = '/newref'

    $.ajax(
      url: prefix+options.url
      data: options.params
      method: options.method
      success: options.success,
      error: (err) =>
        if err.status is 403
          @clean()
          location.href = redirectUrl
        else
          #todo почему модель обращается к разметке???? Исправить
          $('#container .alert-danger').remove()
          $('#container').prepend(window.templates.error(err.responseText))
    )

  ##
  #
  constructor: () ->
    @adapter = new GameAdapter()
    if !(@games = localStorageRead('ref_games')) then @games = null
    if (user = localStorageRead('ref_user')) then @user = user
    if (rosterStatesStack = localStorageRead('ref_roster_stack')) then @rosterStatesStack = rosterStatesStack

  ##
  # спрашиваем у сервера, сохранил ли он сессию, потом смотрим, всё ли в порядке с нашим локал стораджем
  checkAuthentication: (callback, fallback) =>
    @request(
      method: 'GET'
      url: 'session_status'
      success: (isSessionActive) =>
        if isSessionActive && @user.authorized
          callback()
        else
          @clean()
          fallback()
    )

  ##
  #
  save: ->
    localStorageWrite('ref_games', @games)
    localStorageWrite('ref_user', @user)
    localStorageWrite('ref_roster_stack', @rosterStatesStack)

  ##
  # записываем информацию об игре (без синхронизации с сервером)
  setGameStats: (game) =>
    @games[game._id] = game
    @save()

  ##
  # залогиниваем/разлогиниваем юзера
  setUserStatus: (isAuthenticated) =>
    @user.authorized = isAuthenticated

  ##
  #
  login: (model, callback) =>
    @request(
      method: "POST"
      url: 'login'
      params: model
      success: =>
        @setUserStatus(true)
        @save()
        callback()
    )



  ##
  # разлогиниваем юзера, убираем всю загруженную игру об играх
  clean: =>
    @user.authorized = false
    @games = null
    @save()



  ##
  # Мягко перезаписываем информацию об игре. Обновляем всё кроме счёта и статистики игроков.
  # В заявке игроков правим только имя и номер, если поменялись, статсы сохраняем
  safeRewriteGame: (oldGame, newGame) ->
    for teamIndex in [0,1]
      for oldPl in oldGame.teams[teamIndex].players
        #если старый игрок найден в списке новых, перезаписываем его данные
        for newPl in newGame.teams[teamIndex].players
          if newPl._id is oldPl._id
            newPl.number = oldPl.number
            newPl.name   = oldPl.name


      newGame.teams[teamIndex].score = oldGame.teams[teamIndex].score
      newGame.teams[teamIndex].refereeMark = oldGame.teams[teamIndex].refereeMark
    newGame.synced = oldGame.synced

    return newGame

  ##
  # запрашиваем сервер, обновляем список игр
  loadGames: (callback) =>
    @request(
      method: 'GET'
      url: 'games',
      success: (games) =>
        for gm in games
          gm = @adapter.toLocal(gm)
          if !@games? then @games = {}
          if !@games[gm._id]?
            @games[gm._id] = gm
          else
            @games[gm._id] = @safeRewriteGame(@games[gm._id], gm)

        @save()
        callback(@games)
    )

  ##
  # запрашиваем сервис, обнавляем информацию об игре
  loadGame: (id, callback) =>
    @request(
      method: 'GET'
      url: "game?_id=#{id}",
      success: (game) =>
        game = @adapter.toLocal(game)
        @games[id] = @safeRewriteGame(@games[id], game)
        @save()
        callback(id)
    )

  ##
  #
  saveGame: (game, callback) =>
    @request(
      method: 'POST'
      url: "save_game"
      params: @adapter.toServer(game)
      success: =>
        delete @rosterStatesStack[game._id]
        callback()
    )

  ##
  # стек состояний протоколов команд. Хранится в формате gameId: side: players
  rosterStatesStack: {}

  ##
  # отправляем в архив текущее состояние протокола команды
  saveRosterState: (gameId, side) =>

    if !@rosterStatesStack[gameId]?
      @rosterStatesStack[gameId]=
        home: []
        away: []
    teamIndex = if side is 'home' then 0 else 1
    players = ($.extend(true, {}, pl) for pl in @games[gameId].teams[teamIndex].players) #клоним чтобы массив не передавался по ссылке и не видоизменялся потом
    @rosterStatesStack[gameId][side].push(players)

    @save()


  ##
  # восстанавливаем из архива последнее состояние протокола команды
  restoreRosterState: (gameId, side) =>
    teamIndex = if side is 'home' then 0 else 1
    players = @rosterStatesStack[gameId][side].pop()
    @games[gameId].teams[teamIndex].players = players if players?

    @save()
