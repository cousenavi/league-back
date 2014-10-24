async = require('async')

class StatsCompiler

  ##
  # @var app инстанс приложения
  # @var gameAdapter адаптер игры (нужен для плавного рефакторинга)
  ##
  constructor: (@app, @gameAdapter) ->

  ##
  # производим пересчёт статистики при обновлении игры
  #
  onResultAdded: (game) =>
    leagueId = game.leagueId
    @topPlayers(leagueId, (players) =>
      @simpleTable(leagueId, (stagingTable) =>
        @gamePreview(leagueId, stagingTable, players)
      )
    )

  ##
  # @private
  #
  getTeams: (leagueId, callback) =>
    @app.models.Team.find leagueId: leagueId, (err, teams) =>
      if err then throw new Error 'Cannot update simple table'+err
      callback(teams)
  ##
  # @private
  #
  getGames: (leagueId, callback) =>
    @app.models.Game.find(leagueId: leagueId).sort(datetime: 'asc').exec (err, games) =>
      if err then throw new Error 'Cannot update simple table'+err
      callback(games)


  ##
  # сортируем команды по набранным очкам, потом по разнице голов, потом по забитым
  sortByPosition = (a,b) ->
      if a.score > b.score then return -1
      if a.score < b.score then return 1
      if (a.scored - a.conceded) > (b.scored - b.conceded) then return -1
      if (a.scored - a.conceded) < (b.scored - b.conceded) then return 1
      if a.scored > b.scored then return -1
      if a.scored < b.scored then return 1
      return 0


  ##
  # TODO COMPLETELY REFACTORING!!!
  # лучшие игроки
  topPlayers: (leagueId, stCallback) =>
    @getGames leagueId, (games) => @getTeams leagueId, (teams) =>

      mappedTeams = {}
      mappedTeams[t._id] = t for t in teams

      @app.models.Player.find(teamId: $in: teams, (err, players) =>
        records = {}
        for pl in players
          records[pl._id] =
            name: pl.name
            teamLogo: mappedTeams[pl.teamId].logo
            teamId: pl.teamId
            goals: 0
            assists: 0
            stars: 0
            played: 0
            yellow: 0
            red: 0
            points: 0

        for gm in games
          for pl in gm.homeTeamPlayers.concat(gm.awayTeamPlayers)
            if records[pl._id]? #todo КОСТЫЛЬ АДСКИЙ! Продумать что делать если игрок удалён из заявки
              records[pl._id].played++
              records[pl._id].goals += parseInt(pl.goals) if pl.goals
              records[pl._id].assists += parseInt(pl.assists) if pl.assists
              records[pl._id].stars += Boolean(pl.star) if pl.star
              records[pl._id].points += parseInt(pl.goals) if pl.goals
              records[pl._id].points += parseInt(pl.assists) if pl.assists
              records[pl._id].yellow += parseInt(pl.yellow) if pl.yellow
              records[pl._id].red += parseInt(pl.red) if pl.red
              records[pl._id].star += Boolean(pl.star) if pl.star

        records = (record for id, record of records when record.played > 0)

        Top = @app.models.TopPlayers
        Top.findOne(leagueId: leagueId, (err, model) ->
          if  model?
            Top.update({_id: model._id}, players: records, (err, num) ->
              stCallback(records)
            )
          else
            (new Top(leagueId: leagueId, players: records)).save(->
              stCallback(records)
            )
        )
    )

  ##
  # самая простая таблица
  # @model SimpleTable
  # @param leagueId
  # @param previewCallback вызов пересчёта превьюшек
  # хранится запись таблицы по каждому дню, в который были игры
  ##
  simpleTable: (leagueId, previewCallback) =>
#    records = {} #объекты, которые будут записаны в базу
#    @getGames leagueId, (games) => @getTeams leagueId, (teams) =>
#
#      stagingTeamsState = {}
#      for tm in teams
#        stagingTeamsState[tm._id] = {
#          name: tm.name, logo: tm.logo, _id: tm._id, played: 0, scored: 0,
#          conceded: 0, won: 0, draw: 0, lost: 0, score: 0, form: []
#        }
#      stagingTeamsState.update = (tmId, props) ->
#        for key, prop of props
#          for operator, value of prop
#            if operator is '$inc' then @[tmId][key] += value
#            if operator is '$set' then @[tmId][key] = value
#            if operator is '$push' then @[tmId][key].push(value)
#
#      for gm in games
#        if !gm.homeTeamScore? then continue
#        @gameAdapter.toLocal(gm)
#        for tm, key in gm.teams
#          res = (if tm.score > gm.teams[1-key].score then 'w' else if tm.score < gm.teams[1-key].score then 'l' else 'd')
#          stagingTeamsState.update(tm._id,
#              played: {$inc: 1},
#              scored: {$inc: tm.score},
#              conceded: {$inc: gm.teams[1-key].score},
#              form: {$push: res},
#              won: {$inc: (if res is 'w' then 1 else 0)},
#              draw: {$inc: (if res is 'd' then 1 else 0)},
#              lost: {$inc: (if res is 'l' then 1 else 0 )},
#              score: {$inc: (if res is 'w' then 3 else if res is 'd' then 1 else 0)}
##            }
#          )
#        #так как игры отсортированы по дате, мы можем записать в рекордс текущее состояние таблицы (фокусы с JSON - для клонирования)
#        records[gm.date] = teams: JSON.parse(JSON.stringify(stagingTeamsState));
#
#      #проставляем позиции
#      for dt, rec of records
#        #убираем ключи в виде id-шников
#        rec.teams = (tm for id, tm of rec.teams)
#        rec.dt = dt
#        rec.leagueId = leagueId
#
#        rec.teams.sort(@sortByPosition)
#        #ставим позиции (нумерация с 1, так что +1)
#        for tm, pos in rec.teams
#          tm.position = pos+1
#
#
#      updateTable = (record, callback) =>
#        @app.models.SimpleTable.findOne({leagueId: record.leagueId, date: record.dt}, (err, simpleTable) =>
#          if err then throw 'Cannot update SimpleTable: '+err
#          if simpleTable?
#            @app.models.SimpleTable.update({_id: simpleTable._id}, {teams: record.teams}, (err, num) =>
#              if err then throw 'Cannot update SimpleTable'+err
#              callback()
#            )
#          else
#            (new @app.models.SimpleTable({leagueId: record.leagueId, date: record.dt, teams: record.teams})).save( (err) =>
#              if err then throw 'Cannot update SimpleTable'+err
#              callback()
#            )
#        )
#
#      async.each((r for dt, r of records), updateTable, () =>
#        console.log 'simpleTable successfully updated'
#        previewCallback(stagingTeamsState)
#      )


  ##
  # Превьюшки к ещё не сыгранным играм
  # @model GamePreview
  # @param leagueId
  # @param stagingTeamsState текущее состояние таблицы
  # @param players статсы по игрокам
  # хранится по каждой несыгранной игре, по сыгранным удаляются
  gamePreview: (leagueId, stagingTeamsState, players) =>
#    @app.models.GamePreview.remove(leagueId: leagueId, (err) =>
#      if err then throw 'Cannot update GamePreview'+err
#
#      #убираем ключи id и проставляем позиции
#      teamsState = (tm for id, tm of stagingTeamsState)
#      teamsState.sort(@sortByPosition)
#
#      #определяем максимум забитых и пропущенных
#      maxScored = 0; maxConceded = 0;
#      for tm in teamsState
#        maxScored = tm.scored if tm.scored > maxScored
#        maxConceded = tm.conceded if tm.conceded > maxConceded
#
#      tm.position = key + 1 for tm, key in teamsState when typeof(tm) isnt 'function'
#
#
#      #готовим информацию по трём лучшим Г+П в команде и всем остальным в сумме
#      PlInfo = (pl) ->
#        name= pl.name.split(' ')[0].toLowerCase()
#        name = name.toString().charAt(0).toUpperCase() + name.substr(1)
#        {name: name, goals: pl.goals, assists: pl.assists, points: pl.goals + pl.assists}
#
#      bestPlayersBlock = -> {
#        players: []
#        other: new PlInfo(name: 'other', goals: 0, assists: 0)
#        push: (pl) ->
#          @players.push(pl)
#          @players.sort((a, b) ->
#            if a.points > b.points then return -1
#            if a.points < b.points then return 1
#            if a.goals > b.goals then return  -1
#            if a.goals < b.goals then return 1
#            return 0
#          )
#          if @players.length > 3
#            plInfo = @players.pop()
#            @other.goals += plInfo.goals
#            @other.assists += plInfo.assists
#            @other.points += plInfo.points
#      }
#
#      mappedPlayers = {}
#      for pl in players
#        plInfo = new PlInfo(pl)
#        if !mappedPlayers[pl.teamId] then mappedPlayers[pl.teamId] = new bestPlayersBlock()
#        mappedPlayers[pl.teamId].push(plInfo)
#
#      for id, mp of mappedPlayers
#        mappedPlayers[id] = mp.players.concat(mp.other)
#
#      record = (game) ->
#        gameId: game._id
#        leagueId: game.leagueId
#        tourNumber: game.tourNumber
#        teams: []
#        placeName: game.placeName
#        refereeName: game.refereeName
#        date: game.date
#        time: game.time
#        maxScored: maxScored
#        maxConceded: maxConceded
#      records = {}
#
#      @getGames leagueId, (games) =>
#        for gm in games
#          if gm.homeTeamScore? then continue
#          @gameAdapter.toLocal(gm)
#          records[gm._id] = new record(gm)
#          for tm, key in gm.teams
#            for tmTbl in teamsState
#              if tm._id+'' is tmTbl._id+''
#                records[gm._id].teams[key] = {
#                    _id: tm._id,name: tm.name, logo: tmTbl.logo, position: tmTbl.position, form: tmTbl.form,
#                    won: tmTbl.won, draw: tmTbl.draw, lost: tmTbl.lost, played: tmTbl.played,
#                    scored: tmTbl.scored, conceded: tmTbl.conceded,
#                    players: mappedPlayers[tm._id]
#                  }
#
#        updatePreview = (record, callback) =>
#          (new @app.models.GamePreview(record)).save((err) ->
#            if err then throw new Error 'Cannot update gamePreview'+err
#            callback()
#          )
#
#        async.each((r for dt, r of records), updatePreview, () =>
#          console.log 'GamePreviews successfully updated'
#        )
#
#    )


module.exports = StatsCompiler