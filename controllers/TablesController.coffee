class TablesController
  onResultAdded: (game) =>
    @updateSimleTable(game)
    @updateChessTable(game)
    @updateClimbingChart(game)
    @updateTopPlayers(game)
    @updateBestPlayers(game)
    @updateTourSummary(game)


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

        console.log 'maxTour', maxTourNumber

        records = {}
        records[tour] = {} for tour in [1..maxTourNumber]

        definePosition = (pos) ->
          if pos is 'LM' or pos is 'RM'
            'SM'
          else if pos is 'LB' or pos is 'RB'
            'SB'
          else pos

        Player.find(teamId: $in: teams, (err, players) =>
          for pl in players
            for tour in [1..maxTourNumber]
              records[tour][pl._id] =
                name: pl.name
                teamLogo: mappedTeams[pl.teamId].logo
                position: definePosition(pl.position)
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
            if pl.position is 'SB'
              result = 3 if pl.star
              result += (pl.assists + pl.goals)* 0.8
              result -= pl.conceeded* 0.7
            if pl.position is 'CM'
              result = 3 if pl.star
              result += pl.assists + pl.goals
              result -= pl.conceeded* 0.7
            if pl.position is 'SM'
              result = 3 is pl.star
              result += pl.assists + pl.goals*0.9
              result -= pl.conceeded*0.2
            if pl.position is 'ST'
              result = 3 is pl.star
              result += pl.assists*0.9 + pl.goals
            return result

          for gm in games
            for pl in gm.homeTeamPlayers.concat(gm.awayTeamPlayers)
              if records[gm.tourNumber][pl._id]? #todo !!!
                records[gm.tourNumber][pl._id].goals     = parseInt(pl.goals) if pl.goals
                records[gm.tourNumber][pl._id].assists   = parseInt(pl.assists) if pl.assists
                records[gm.tourNumber][pl._id].star      =   Boolean(pl.star)

            for pl in gm.homeTeamPlayers
              if records[gm.tourNumber][pl._id]? #todo !!!
                records[gm.tourNumber][pl._id].conceeded = gm.awayTeamScore
                records[gm.tourNumber][pl._id].result    = calculateResult(records[gm.tourNumber][pl._id])
            for pl in gm.awayTeamPlayers
              if records[gm.tourNumber][pl._id]? #todo !!!
                records[gm.tourNumber][pl._id].conceeded = gm.homeTeamScore
                records[gm.tourNumber][pl._id].result    = calculateResult(records[gm.tourNumber][pl._id])

          for tour, record of records

            bestPlayers = {}
            for id, pl of record

              if pl.position is 'SM'
                if !bestPlayers['LM']? or bestPlayers['LM'].result < pl.result
                  if bestPlayers['LM']?
                    bestPlayers['RM'] = bestPlayers['LM']
                    bestPlayers['RM'].position = 'RM'
                  bestPlayers['LM'] = pl
                  pl.position = 'LM'
                else if !bestPlayers['RM']? or bestPlayers['RM'].result < pl.result
                  bestPlayers['RM'] = pl
                  pl.position = 'RM'

              else if pl.position is 'SB'
                if !bestPlayers['LB']? or bestPlayers['LB'].result < pl.result
                  if bestPlayers['LB']?
                    bestPlayers['RB'] = bestPlayers['LB']
                    bestPlayers['RB'].position = 'RB'
                  bestPlayers['LB'] = pl
                  pl.position = 'LB'
                else if !bestPlayers['RB']? or bestPlayers['RB'].result < pl.result
                  bestPlayers['RB'] = pl
                  pl.position = 'RB'
              else
                bestPlayers[pl.position] = pl if !bestPlayers[pl.position]? or bestPlayers[pl.position].result < pl.result

            bestPlayers = (pl for id, pl of bestPlayers)

            @app.models.BestPlayers.findOneAndUpdate({leagueId: game.leagueId, tourNumber: tour}, {players: bestPlayers}, {upsert: true}, (err, model) ->
              console.log "best players: err #{err} model #{model}"
            )
        )
      )
    )

  updateTourSummary: (game) ->
    @app.models.Game.find({leagueId: game.leagueId}, (err, models) =>
      @app.models.League.findById(game.leagueId, (err, league) =>
        summaries = {}
        tops = {}

        for gm in models
          if not tops[gm.tourNumber]?
            tops[gm.tourNumber] = {
              teamGoals:0, teamConceed: 100, teamRude: 0, goalscorer: 0, ass: 0
            }
          if not summaries[gm.tourNumber]?
            summaries[gm.tourNumber] = {
              tourNumber: gm.tourNumber,
              leagueId: gm.leagueId,
              leagueName: league.name, leagueLogo: league.logo,
              played: 0, scored: 0, yellow: 0, red: 0,
              mostRudeTeams: []
            }
          summaries[gm.tourNumber].played++
          summaries[gm.tourNumber].scored += gm.homeTeamScore + gm.awayTeamScore

          #
          if gm.homeTeamScore > 0
            if gm.homeTeamScore > tops[gm.tourNumber].teamGoals
              tops[gm.tourNumber].teamGoals = gm.homeTeamScore
              summaries[gm.tourNumber].topScoredTeams = [{goals: gm.homeTeamScore, name: gm.homeTeamName, logo: gm.homeTeamLogo}]
            else if gm.homeTeamScore is 0
              summaries[gm.tourNumber].topScoredTeams.push {goals: gm.homeTeamScore, name: gm.homeTeamName, logo: gm.homeTeamLogo}
          if gm.awayTeamScore > 0
            if gm.awayTeamScore > tops[gm.tourNumber].teamGoals
              tops[gm.tourNumber].teamGoals = gm.awayTeamScore
              summaries[gm.tourNumber].topScoredTeams = [{goals: gm.awayTeamScore, teamName: gm.awayTeamName, logo: gm.awayTeamLogo}]
            else if gm.awayTeamScore is 0
              summaries[gm.tourNumber].topScoredTeams.push {goals: gm.awayTeamScore, teamName: gm.awayTeamName, logo: gm.awayTeamLogo}
          #

          if gm.homeTeamScore?
            if gm.homeTeamScore < tops[gm.tourNumber].teamConceed
              tops[gm.tourNumber].teamConceed = gm.homeTeamScore
              summaries[gm.tourNumber].lessConceededTeams = [{goals: gm.homeTeamScore, name: gm.awayTeamName, logo: gm.awayTeamLogo}]
            else if gm.homeTeamScore is tops[gm.tourNumber].teamConceed
              summaries[gm.tourNumber].lessConceededTeams.push {goals: gm.homeTeamScore, name: gm.awayTeamName, logo: gm.awayTeamLogo}
            if gm.awayTeamScore < tops[gm.tourNumber].teamConceed
              tops[gm.tourNumber].teamConceed = gm.awayTeamScore
              summaries[gm.tourNumber].lessConceededTeams = [{goals: gm.awayTeamScore, name: gm.homeTeamName, logo: gm.homeTeamLogo}]
            else if gm.awayTeamScore is tops[gm.tourNumber].teamConceed
              summaries[gm.tourNumber].lessConceededTeams.push {goals: gm.awayTeamScore, name: gm.homeTeamName, logo: gm.homeTeamLogo}

          teamYellow = teamRed = 0
          teamYellow += (if pl.yellow > 0 then parseInt(pl.yellow) else 0) for pl in gm.homeTeamPlayers
          teamRed    += (if pl.red > 0 then parseInt(pl.red) else 0) for pl in gm.homeTeamPlayers
          if teamYellow + 2*teamRed is tops[gm.tourNumber].teamRude
            summaries[gm.tourNumber].mostRudeTeams.push {name: gm.homeTeamName, logo: gm.homeTeamLogo, yellow: teamYellow, red: teamRed}
          else if  teamYellow + 2*teamRed > tops[gm.tourNumber].teamRude
            summaries[gm.tourNumber].mostRudeTeams =  [{name: gm.homeTeamName, logo: gm.homeTeamLogo, yellow: teamYellow, red: teamRed}]
            tops[gm.tourNumber].teamRude = teamYellow + 2*teamRed

          teamYellow = teamRed = 0
          teamYellow += (if pl.yellow > 0 then parseInt(pl.yellow) else 0) for pl in gm.awayTeamPlayers
          teamRed    += (if pl.red > 0 then parseInt(pl.red) else 0) for pl in gm.awayTeamPlayers
          if teamYellow + 2*teamRed is tops[gm.tourNumber].teamRude
            summaries[gm.tourNumber].mostRudeTeams.push {name: gm.awayTeamName, logo: gm.awayTeamName, yellow: teamYellow, red: teamRed}
          else if  teamYellow + 2*teamRed > tops[gm.tourNumber].teamRude
            summaries[gm.tourNumber].mostRudeTeams =  [{name: gm.awayTeamName, logo: gm.awayTeamName, yellow: teamYellow, red: teamRed}]
            tops[gm.tourNumber].teamRude = teamYellow + 2*teamRed


          for pl in gm.homeTeamPlayers
            summaries[gm.tourNumber].yellow += if pl.yellow then parseInt(pl.yellow) else 0
            summaries[gm.tourNumber].red    += if pl.red then parseInt(pl.red) else 0
            #
            if pl.goals > 0
              if pl.goals is tops[gm.tourNumber].goalscorer
                summaries[gm.tourNumber].topGoalscorers.push({name: pl.name, teamLogo: gm.homeTeamLogo, goals: pl.goals} )
              else if pl.goals > tops[gm.tourNumber].goalscorer
                tops[gm.tourNumber].goalscorer = pl.goals
                summaries[gm.tourNumber].topGoalscorers = [{name: pl.name, teamLogo: gm.homeTeamLogo, goals: pl.goals}]
            #
            if pl.assists > 0
              if pl.assists is tops[gm.tourNumber].ass
                summaries[gm.tourNumber].topAssistants.push({name: pl.name, teamLogo: gm.homeTeamLogo, assists: pl.assists} )
              else if pl.assists > tops[gm.tourNumber].ass
                tops[gm.tourNumber].ass = pl.assists
                summaries[gm.tourNumber].topAssistants = [{name: pl.name, teamLogo: gm.homeTeamLogo, assists: pl.assists}]

          for pl in gm.awayTeamPlayers
            summaries[gm.tourNumber].yellow += if pl.yellow then parseInt(pl.yellow) else 0
            summaries[gm.tourNumber].red    += if pl.red then parseInt(pl.red) else 0
            #
            if pl.goals > 0
              if pl.goals is tops[gm.tourNumber].goalscorer
                summaries[gm.tourNumber].topGoalscorers.push({name: pl.name, teamLogo: gm.awayTeamLogo, goals: pl.goals} )
              else if pl.goals > tops[gm.tourNumber].goalscorer
                tops[gm.tourNumber].goalscorer = pl.goals
                summaries[gm.tourNumber].topGoalscorers = [{name: pl.name, teamLogo: gm.awayTeamLogo, goals: pl.goals}]
            #
            if pl.assists > 0
              if pl.assists is tops[gm.tourNumber].ass
                summaries[gm.tourNumber].topAssistants.push({name: pl.name, teamLogo: gm.awayTeamLogo, assists: pl.assists} )
              else if pl.assists > tops[gm.tourNumber].ass
                tops[gm.tourNumber].ass = pl.assists
                summaries[gm.tourNumber].topAssistants = [{name: pl.name, teamLogo: gm.awayTeamLogo, assists: pl.assists}]




        for tourNumber, summary of summaries
          @app.models.TourSummary.findOneAndUpdate({leagueId: summary.leagueId, tourNumber: tourNumber}, {$set: summary}, {upsert: true}, (err, models) ->
            console.log "tour summary. Error: #{err}, RowCount: #{models}"
            )
      )
    )


  getTourSummary: (req, res) ->
    Model = req.app.models.TourSummary

    Model.findOne(req.query, (err, model) ->
      res.send model
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
    req.app.models.BestPlayers.find({leagueId: req.query.leagueId, tourNumber: req.query.tourNumber},  (err, model) ->
      res.send model
    )



module.exports = new TablesController()

