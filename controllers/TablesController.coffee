class TablesController
  onResultAdded: (game) =>
    @updateSimleTable(game)
    @updateChessTable(game)
    @updateClimbingChart(game)

  ###
    График набора очков
  ###
  updateClimbingChart: (game) =>
    Game = @app.models.Game
    Team = @app.models.Team

    Game.find(leagueId: game.leagueId).sort(datetime: 'asc').exec((err, games) =>
      Team.find(leagueId: game.leagueId, (err, teams) =>
        records = {}
        for team in teams
          records[team._id] =
            name: team.name
            data: []
        games = (game for game in games when game.homeTeamScore?)

        for game in games
          records[game.homeTeamId].data.push(
            if game.homeTeamScore > game.awayTeamScore then 3 else if game.homeTeamScore is game.awayTeamScore then 1 else 0
          )
          records[game.awayTeamId].data.push(
            if game.homeTeamScore > game.awayTeamScore then 0 else if game.homeTeamScore is game.awayTeamScore then 1 else 3
          )

        records = (record for id, record of records)

        Model = @app.models.ClimbingChart
        Model.findOne(leagueId: game.leagueId, (err, model) ->
          if  model?
            Model.update({_id: model._id}, series: records, (err, num) -> console.log err, num)
          else
            (new Model(leagueId: game.leagueId, series: records)).save()
        )
      )
    )

  ###
    Шахматка
  ###
  updateChessTable: (game) =>
    Game = @app.models.Game
    Team = @app.models.Team

    Game.find(leagueId: game.leagueId).sort(datetime: 'asc').exec((err, games) =>
      Team.find(leagueId: game.leagueId, (err, teams) =>
        records = {}
        for team in teams
          records[team._id] =
            name: team.name
            _id: team.id
            logo: team.logo
            home: []
            away: []

        games = (game for game in games when game.homeTeamScore?)

        for game in games
          records[game.homeTeamId].home.push({'scored': game.homeTeamScore, 'conceeded': game.awayTeamScore,            'opponent': game.awayTeamId})
          records[game.awayTeamId].away.push({'scored': game.awayTeamScore, 'conceeded': game.homeTeamScore,            'opponent': game.homeTeamId})

        records = (record for id, record of records)

        Model = @app.models.ChessTable
        Model.findOne(leagueId: game.leagueId, (err, model) ->
          if  model?
            Model.update({_id: model._id}, teams: records, (err, num) -> console.log err, num)
          else
            (new Model(leagueId: game.leagueId, teams: records)).save()
        )
      )
    )

  ###
    Самая простая таблица
  ###
  updateSimleTable: (game) =>
    Game = @app.models.Game
    Team = @app.models.Team

    Game.find(leagueId: game.leagueId).sort(datetime: 'asc').exec((err, games) =>
      Team.find(leagueId: game.leagueId, (err, teams) =>

        records = {}
        for team in teams
          records[team._id] =
            name: team.name
            _id: team._id
            position: 0
            played: 0
            won: 0
            draw: 0
            lost: 0
            score: 0
            goalsScored: 0
            goalsConceded: 0
            form: []

        games = (game for game in games when game.homeTeamScore?)

        for game in games

          records[game.homeTeamId].played += 1
          records[game.homeTeamId].goalsScored   += game.homeTeamScore
          records[game.homeTeamId].goalsConceded += game.awayTeamScore
          records[game.homeTeamId].won +=  (if game.homeTeamScore > game.awayTeamScore then 1 else 0)
          records[game.homeTeamId].draw +=  (if game.homeTeamScore == game.awayTeamScore then 1 else 0)
          records[game.homeTeamId].lost +=  (if game.homeTeamScore < game.awayTeamScore then 1 else 0)
          records[game.homeTeamId].score += (if game.homeTeamScore > game.awayTeamScore then 3 else
                                              if game.homeTeamScore == game.awayTeamScore then 1 else 0)
          records[game.homeTeamId].form.push(
            (if game.homeTeamScore > game.awayTeamScore then 'W' else
              if game.homeTeamScore is game.awayTeamScore then 'D' else 'L')
          )

          records[game.awayTeamId].played += 1
          records[game.awayTeamId].goalsScored   += game.awayTeamScore
          records[game.awayTeamId].goalsConceded += game.homeTeamScore
          records[game.awayTeamId].won +=  (if game.homeTeamScore < game.awayTeamScore then 1 else 0)
          records[game.awayTeamId].draw +=  (if game.homeTeamScore == game.awayTeamScore then 1 else 0)
          records[game.awayTeamId].lost +=  (if game.homeTeamScore > game.awayTeamScore then 1 else 0)
          records[game.awayTeamId].score += (if game.homeTeamScore < game.awayTeamScore then 3 else
            if game.homeTeamScore == game.awayTeamScore then 1 else 0)
          records[game.awayTeamId].form.push(
            (if game.homeTeamScore > game.awayTeamScore then 'L' else
              if game.homeTeamScore is game.awayTeamScore then 'D' else 'W')
          )

        records = (record for id, record of records)

        records.sort( (a, b) ->
            if a.score > b.score then return -1
            if a.score < b.score then return 1
            if (a.goalsScored - a.goalsConceded) > (b.goalsScored - b.goalsConceded) then return -1
            if (a.goalsScored - a.goalsConceded) < (b.goalsScored - b.goalsConceded) then return 1
            if a.goalsScored > b.goalsScored then return -1
            if a.goalsScored < b.goalsScored then return 1
            return 0
          )

        for record, position in records
          record.position = position + 1 #потому что нумерация с нуля


        Model = @app.models.SimpleTable
        Model.findOne(leagueId: game.leagueId, (err, model) ->
          if  model?
            Model.update({_id: model._id}, teams: records, (err, num) -> console.log err, num)
          else
            (new Model(leagueId: game.leagueId, teams: records)).save()
        )

      ))


  getSimpleTable: (req, res) ->
    Model = req.app.models.SimpleTable

    Model.findOne(req.query, (err, model) ->
      res.send model
    )

  getChessTable: (req, res) ->
    Model = req.app.models.ChessTable

    Model.findOne(req.query, (err, model) ->
      res.send model
    )

  getClimbingChart: (req, res) ->
    Model = req.app.models.ClimbingChart

    Model.findOne(req.query, (err, model) ->
      res.send model
    )

  getTopGoalscorers: (req, res) ->
    Model = req.app.models.TopGoalscorers

    Model.findOne(req.query, (err, model) ->
      res.send model
    )

  getTopAssistants: (req, res) ->
    Model = req.app.models.TopAssistants

    Model.findOne(req.query, (err, model) ->
      res.send model
    )

  getTopPoints: (req, res) ->
    Model = req.app.models.TopPoints

    Model.findOne(req.query, (err, model) ->
      res.send model
    )

  getTopStars: (req, res) ->
    Model = req.app.models.TopStars

    Model.findOne(req.query, (err, model) ->
      res.send model
    )


module.exports = new TablesController()

