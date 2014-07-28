class TablesController
  onResultAdded: (game) =>
    @updateSimleTable(game)
    @updateChessTable(game)
    @updateClimbingChart(game)
    @updateTopPlayers(game)

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
            data: [0]
        games = (game for game in games when game.homeTeamScore?)

        for game in games
          hm = records[game.homeTeamId].data
          aw = records[game.awayTeamId].data

          newScore = hm[hm.length - 1] +  (if game.homeTeamScore > game.awayTeamScore then 3 else if game.homeTeamScore is game.awayTeamScore then 1 else 0)
          records[game.homeTeamId].data.push(newScore)

          newScore = aw[aw.length - 1] +  (if game.homeTeamScore > game.awayTeamScore then 0 else if game.homeTeamScore is game.awayTeamScore then 1 else 3)
          records[game.awayTeamId].data.push(newScore)

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

  updateTopPlayers: (game) ->
    Game = @app.models.Game
    Team = @app.models.Team
    Player = @app.models.Player

    Game.find(leagueId: game.leagueId, (err, games) =>
      Team.find(leagueId: game.leagueId, (err, teams) =>

        mappedTeams = {}
        mappedTeams[t._id] = t for t in teams

        Player.find(teamId: $in: teams, (err, players) =>
          records = {}
          for pl in players
            records[pl._id] =
              name: pl.name
              teamLogo: mappedTeams[pl.teamId].logo
              goals: 0
              assists: 0
              star: 0
              played: 0
              yellow: 0
              red: 0
              points: 0

          for gm in games
            for pl in gm.homeTeamPlayers.concat(gm.awayTeamPlayers)
              records[pl._id].played++
              records[pl._id].goals += parseInt(pl.goals) if pl.goals
              records[pl._id].assists += parseInt(pl.assists) if pl.assists
              records[pl._id].points += records[pl._id].goals + records[pl._id].assists
              records[pl._id].yellow += parseInt(pl.yellow) if pl.yellow
              records[pl._id].red += parseInt(pl.red) if pl.red
              records[pl._id].star += Boolean(pl.star) if pl.star

          goalscorers = ({name: pl.name, teamLogo: pl.teamLogo, goals: pl.goals, played: pl.played} for k, pl of records when pl.goals > 0)
          assistants = ({name: pl.name, teamLogo: pl.teamLogo, assists: pl.assists, played: pl.played} for k, pl of records when pl.assists > 0)
          points = ({name: pl.name, teamLogo: pl.teamLogo, points: pl.points, goals: pl.goals, assists: pl.assists, played: pl.played} for k, pl of records when pl.points > 0)
          stars = ({name: pl.name, teamLogo: pl.teamLogo, stars: pl.stars, played: pl.played} for k, pl of records when pl.stars > 0)
          cards = ({name: pl.name, teamLogo: pl.teamLogo, yellow: pl.yellow, red: pl.red, played: pl.played} for k, pl of records when pl.yellow + pl.red > 0)

          sortByFields = (fieldNames) ->
            return (a,b) ->
              for fieldName in fieldNames
                if a[fieldName] < b[fieldName] then return 1
                if a[fieldName] > b[fieldName] then return -1
              return 0

          goalscorers.sort sortByFields(['goals', 'played'])
          assistants.sort  sortByFields(['assists', 'played'])
          points.sort      sortByFields(['points', 'played'])
          stars.sort       sortByFields(['stars', 'played'])
          cards.sort       sortByFields(['red', 'yellow'])

          Gs = @app.models.TopGoalscorers
          Gs.findOne(leagueId: game.leagueId, (err, model) ->
            if  model?
              Gs.update({_id: model._id}, players: goalscorers, (err, num) -> console.log  err, num)
            else
              (new Gs(leagueId: game.leagueId, players: goalscorers)).save()
          )

          As = @app.models.TopAssistants
          As.findOne(leagueId: game.leagueId, (err, model) ->
            if  model?
              As.update({_id: model._id}, players: assistants, (err, num) -> console.log err, num)
            else
              (new As(leagueId: game.leagueId, players: assistants)).save()
          )
          Pts = @app.models.TopPoints
          Pts.findOne(leagueId: game.leagueId, (err, model) ->
            if  model?
              Pts.update({_id: model._id}, players: points, (err, num) -> console.log err, num)
            else
              (new Pts(leagueId: game.leagueId, players: points)).save()
          )
          Strs = @app.models.TopStars
          Strs.findOne(leagueId: game.leagueId, (err, model) ->
            if  model?
              Strs.update({_id: model._id}, players: stars, (err, num) -> console.log err, num)
            else
              (new Strs(leagueId: game.leagueId, players: stars)).save()
          )
          Crds = @app.models.TopCards
          Crds.findOne(leagueId: game.leagueId, (err, model) ->
            if  model?
              Crds.update({_id: model._id}, players: cards, (err, num) -> console.log err, num)
            else
              (new Crds(leagueId: game.leagueId, players: cards)).save()
          )

        )
      )
    )

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
      console.log err, model

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

