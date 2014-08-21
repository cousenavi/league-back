class TablesController
  onResultAdded: (game) =>
    @updateSimleTable(game)
    @updateChessTable(game)
    @updateClimbingChart(game)
    @updateTopPlayers(game)
    @updateBestPlayers(game)


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
            games: {}

          for tm in teams
            records[team._id].games[tm._id] = []

        games = (game for game in games when game.homeTeamScore?)

        for game in games
          records[game.homeTeamId].games[game.awayTeamId].push({'scored': game.homeTeamScore, 'conceeded': game.awayTeamScore})
          records[game.awayTeamId].games[game.homeTeamId].push({'scored': game.awayTeamScore, 'conceeded': game.homeTeamScore})

        records = (record for id, record of records)
        records.sort((a,b) -> if a._id > b._id then 1 else - 1)
        for t in records
          t.games = ({opponent: id, matches: g} for id, g of t.games).sort((a,b) -> if a.opponent > b.opponent then 1 else - 1)


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
            logo: team.logo
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
              stars: 0
              played: 0
              yellow: 0
              red: 0
              points: 0

          for gm in games
            for pl in gm.homeTeamPlayers.concat(gm.awayTeamPlayers)
              records[pl._id].played++
              records[pl._id].goals += parseInt(pl.goals) if pl.goals
              records[pl._id].assists += parseInt(pl.assists) if pl.assists
              records[pl._id].stars += Boolean(pl.star) if pl.star
              records[pl._id].points += records[pl._id].goals + records[pl._id].assists
              records[pl._id].yellow += parseInt(pl.yellow) if pl.yellow
              records[pl._id].red += parseInt(pl.red) if pl.red
              records[pl._id].star += Boolean(pl.star) if pl.star

          records = (record for id, record of records when record.played > 0)

          Top = @app.models.TopPlayers
          Top.findOne(leagueId: game.leagueId, (err, model) ->
            if  model?
              Top.update({_id: model._id}, players: records, (err, num) -> console.log err, num)
            else
              (new Top(leagueId: game.leagueId, players: records)).save(-> console.log err, num)
          )

        )
      )
    )

  updateBestPlayers: (game) =>
    Game = @app.models.Game
    Team = @app.models.Team
    Player = @app.models.Player

    Game.find(leagueId: game.leagueId, (err, games) =>
      Team.find(leagueId: game.leagueId, (err, teams) =>

        mappedTeams = {}
        mappedTeams[t._id] = t for t in teams

        maxTourNumber = 0
        for gm in games
          maxTourNumber = gm.tourNumber if gm.tourNumber > maxTourNumber
        if maxTourNumber is 0 then return

        records = {}
        records[tour] = {} for tour in [0..maxTourNumber]

        Player.find(teamId: $in: teams, (err, players) =>
          for pl in players
            for tour in [0..maxTourNumber]
              records[tour][pl._id] =
                name: pl.name
                teamLogo: mappedTeams[pl.teamId].logo
                position: pl.position
                conceeded: 0
                goals: 0
                assists: 0
                star: false
                result: 0


          calculateResult = (pl) ->
            result = 0
            if pl.position is 'GK'
              result = 3 if pl.star
              result += pl.assists*0.5 + pl.goals
              result -= pl.conceeded
            if pl.position is 'CB'
              result = 3 if pl.star
              result += (pl.assists + pl.goals)* 0.6
              result -= pl.conceeded*0.8
            if pl.position is 'RB' or pl.position is 'LB'
              result = 3 if pl.star
              result += (pl.assists + pl.goals)* 0.8
              result -= pl.conceeded* 0.7
            if pl.position is 'CM'
              result = 3 if pl.star
              result += pl.assists + pl.goals
              result -= pl.conceeded* 0.7
            if pl.position is 'RM' or pl.position is 'LM'
              result = 3 is pl.star
              result += pl.assists + pl.goals*0.9
              result -= pl.conceeded*0.2
            if pl.position is 'ST'
              result = 3 is pl.star
              result += pl.assists*0.9 + pl.goals
            return result

          for gm in games
            for pl in gm.homeTeamPlayers.concat(gm.awayTeamPlayers)
              records[gm.tourNumber][pl._id].goals     = parseInt(pl.goals) if pl.goals
              records[gm.tourNumber][pl._id].assists   = parseInt(pl.assists) if pl.assists
              records[gm.tourNumber][pl._id].star      = Boolean(pl.star)
            for pl in gm.homeTeamPlayers
              records[gm.tourNumber][pl._id].conceeded = gm.awayTeamScore
              records[gm.tourNumber][pl._id].result    = calculateResult(records[gm.tourNumber][pl._id])
            for pl in gm.awayTeamPlayers
              records[gm.tourNumber][pl._id].conceeded = gm.homeTeamScore
              records[gm.tourNumber][pl._id].result    = calculateResult(records[gm.tourNumber][pl._id])

          for tour, record of records
            bestPlayers = {}
            for id, pl of record
              bestPlayers[pl.position] = pl if !bestPlayers[pl.position]? or bestPlayers[pl.position].result < pl.result
            bestPlayers = (pl for id, pl of bestPlayers)

            @app.models.BestPlayers.update({leagueId: game.leagueId, tourNumber: tour}, {players: bestPlayers}, {upsert: true})
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


  getTopPlayers: (req, res) ->
    Model = req.app.models.TopPlayers

    Model.findOne(leagueId: req.query.leagueId, (err, model) ->
        res.send model
    )

  getBestPlayers: (req, res) ->
    req.app.models.BestPlayers.find(leagueId: req.query.leagueId, (err, model) ->
      res.send model
    )



module.exports = new TablesController()

