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
    @simpleTable(game.leagueId)

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
  # самая простая таблица
  # @model SimpleTable
  # @param leagueId
  # хранится запись таблицы по каждому дню, в который были игры
  ##
  simpleTable: (leagueId) =>
    records = {} #объекты, которые будут записаны в базу
    @getGames leagueId, (games) => @getTeams leagueId, (teams) =>

      stagingTeamsState = {}
      for tm in teams
        stagingTeamsState[tm._id] = {
          name: tm.name, logo: tm.logo, _id: tm._id, played: 0, scored: 0,
          conceded: 0, won: 0, draw: 0, lost: 0, score: 0, form: []
        }
      stagingTeamsState.update = (tmId, props) ->
        for key, prop of props
          for operator, value of prop
            if operator is '$inc' then @[tmId][key] += value
            if operator is '$set' then @[tmId][key] = value
            if operator is '$push' then @[tmId][key].push(value)

      for gm in games
        @gameAdapter.toLocal(gm)
        if !gm.teams[0].score? then continue
        for tm, key in gm.teams
          res = (if tm.score > gm.teams[1-key].score then 'w' else if tm.score < gm.teams[1-key].score then 'l' else 'd')
          stagingTeamsState.update(tm._id, 
              played: {$inc: 1},
              scored: {$inc: tm.score},
              conceded: {$inc: gm.teams[1-key].score},
              form: {$push: res},
              won: {$inc: (if res is 'w' then 1 else 0)},
              draw: {$inc: (if res is 'd' then 1 else 0)},
              lost: {$inc: (if res is 'l' then 1 else 0 )},
              score: {$inc: (if res is 'w' then 3 else if res is 'd' then 1 else 0)}
#            }
          )
        #так как игры отсортированы по дате, мы можем записать в рекордс текущее состояние таблицы (фокусы с JSON - для клонирования)
        records[gm.date] = teams: JSON.parse(JSON.stringify(stagingTeamsState));

      #проставляем позиции
      for dt, rec of records
        #убираем ключи в виде id-шников
        rec.teams = (tm for id, tm of rec.teams)
        rec.dt = dt
        rec.leagueId = leagueId

        rec.teams.sort((a, b) ->
          if a.score > b.score then return -1
          if a.score < b.score then return 1
          if (a.scored - a.conceded) > (b.scored - b.conceded) then return -1
          if (a.scored - a.conceded) < (b.scored - b.conceded) then return 1
          if a.scored > b.scored then return -1
          if a.scored < b.scored then return 1
          return 0
        )
        #ставим позиции (нумерация с 1, так что +1)
        for tm, pos in rec.teams
          tm.position = pos+1


      updateTable = (record, callback) =>
        @app.models.SimpleTable.findOne({leagueId: record.leagueId, date: record.dt}, (err, simpleTable) =>
          if err then throw 'Cannot update SimpleTable: '+err
          if simpleTable?
            @app.models.SimpleTable.update({_id: simpleTable._id}, {teams: record.teams}, (err, num) =>
              if err then throw 'Cannot update SimpleTable'+err
              callback()
            )
          else
            (new @app.models.SimpleTable({leagueId: record.leagueId, date: record.dt, teams: record.teams})).save( (err) =>
              if err then throw 'Cannot update SimpleTable'+err
              callback()
            )
        )

      async.each((r for dt, r of records), updateTable, () =>
        console.log 'simpleTable successfully updated'
        process.exit(0)
      )

module.exports = StatsCompiler