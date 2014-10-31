class TablesController
  onResultAdded: (game) =>
    @updateChessTable(game)
    @updateClimbingChart(game)
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

  ##
  # private
  # Прокручиваем все игры, чтобы определить серии побед и поражений
  defineFormsRecords = (games) ->
    teamsForm = {}
    for gm in games
      if gm.homeTeamScore?
        if !teamsForm[gm.homeTeamId] then teamsForm[gm.homeTeamId] = {name: gm.homeTeamName, logo: gm.homeTeamLogo, form: []}
        if !teamsForm[gm.awayTeamId] then teamsForm[gm.awayTeamId] = {name: gm.awayTeamName, logo: gm.awayTeamLogo, form: []}

        if gm.homeTeamScore > gm.awayTeamScore
          teamsForm[gm.homeTeamId].form.push('w')
          teamsForm[gm.awayTeamId].form.push('l')
        else if gm.homeTeamScore < gm.awayTeamScore
          teamsForm[gm.homeTeamId].form.push('l')
          teamsForm[gm.awayTeamId].form.push('w')
        else if  gm.homeTeamScore is gm.awayTeamScore
          teamsForm[gm.homeTeamId].form.push('d')
          teamsForm[gm.awayTeamId].form.push('d')

    formsRecords = {
      withoutLoses: {games: 0, teams: []},
      withoutWins:  {games: 0, teams: []}
      withoutLosesBest: {games: 0, teams: []},
      withoutWinsBest:  {games: 0, teams: []}
    }
    #прокручиваем форму команд чтобы определить, у кого рекордная серия побед и поражений
    for teamId, team of teamsForm
      nolose = 0; noloseBest = 0
      nowin = 0; nowinBest = 0
      for res in team.form
        if res isnt 'l'
          nolose++
          if nolose > noloseBest then noloseBest = nolose
        else
          if nolose > noloseBest then noloseBest = nolose
          nolose = 0

        if res isnt 'w'
          nowin++
          if nowin > nowinBest then nowinBest = nowin
        else
          if nowin > nowinBest then nowinBest = nowin
          nowin = 0

      if nolose > formsRecords.withoutLoses.games
        formsRecords.withoutLoses = {games: nolose, teams: [{name: team.name, logo: team.logo}]}
      else if nolose is formsRecords.withoutLoses.games
        formsRecords.withoutLoses.teams.push  {name: team.name, logo: team.logo}

      if noloseBest > formsRecords.withoutLosesBest.games
        formsRecords.withoutLosesBest = {games: noloseBest, teams: [{name: team.name, logo: team.logo}]}
      else if noloseBest is formsRecords.withoutLosesBest.games
        formsRecords.withoutLosesBest.teams.push  {name: team.name, logo: team.logo}

      if nowin > formsRecords.withoutWins.games
        formsRecords.withoutWins = {games: nowin, teams: [{name: team.name, logo: team.logo}]}
      else if nowin is formsRecords.withoutWins.games
        formsRecords.withoutWins.teams.push  {name: team.name, logo: team.logo}

      if nowinBest > formsRecords.withoutWinsBest.games
        formsRecords.withoutWinsBest = {games: nowinBest, teams: [{name: team.name, logo: team.logo}]}
      else if nowinBest is formsRecords.withoutWinsBest.games
        formsRecords.withoutWinsBest.teams.push  {name: team.name, logo: team.logo}

    return formsRecords


  updateTourSummary: (game) ->
    @app.models.Game.find({leagueId: game.leagueId}).sort(datetime: 'asc').exec( (err, models) =>
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
            else if gm.homeTeamScore is tops[gm.tourNumber].teamGoals
              summaries[gm.tourNumber].topScoredTeams.push {goals: gm.homeTeamScore, name: gm.homeTeamName, logo: gm.homeTeamLogo}
          if gm.awayTeamScore > 0
            if gm.awayTeamScore > tops[gm.tourNumber].teamGoals
              tops[gm.tourNumber].teamGoals = gm.awayTeamScore
              summaries[gm.tourNumber].topScoredTeams = [{goals: gm.awayTeamScore, name: gm.awayTeamName, logo: gm.awayTeamLogo}]
            else if gm.awayTeamScore is tops[gm.tourNumber].teamGoals
              summaries[gm.tourNumber].topScoredTeams.push {goals: gm.awayTeamScore, name: gm.awayTeamName, logo: gm.awayTeamLogo}
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
          if tops[gm.tourNumber].teamRude > 0 and teamYellow + 2*teamRed is tops[gm.tourNumber].teamRude
            summaries[gm.tourNumber].mostRudeTeams.push {name: gm.homeTeamName, logo: gm.homeTeamLogo, yellow: teamYellow, red: teamRed}
          else if  teamYellow + 2*teamRed > tops[gm.tourNumber].teamRude
            summaries[gm.tourNumber].mostRudeTeams =  [{name: gm.homeTeamName, logo: gm.homeTeamLogo, yellow: teamYellow, red: teamRed}]
            tops[gm.tourNumber].teamRude = teamYellow + 2*teamRed

          teamYellow = teamRed = 0
          teamYellow += (if pl.yellow > 0 then parseInt(pl.yellow) else 0) for pl in gm.awayTeamPlayers
          teamRed    += (if pl.red > 0 then parseInt(pl.red) else 0) for pl in gm.awayTeamPlayers
          if tops[gm.tourNumber].teamRude > 0 and teamYellow + 2*teamRed is tops[gm.tourNumber].teamRude
            summaries[gm.tourNumber].mostRudeTeams.push {name: gm.awayTeamName, logo: gm.awayTeamName, yellow: teamYellow, red: teamRed}
          else if  teamYellow + 2*teamRed > tops[gm.tourNumber].teamRude
            summaries[gm.tourNumber].mostRudeTeams =  [{name: gm.awayTeamName, logo: gm.awayTeamName, yellow: teamYellow, red: teamRed}]
            tops[gm.tourNumber].teamRude = teamYellow + 2*teamRed



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




        #todo вряд ли нужно так уж денормализовать таблицу и хранить рекорды в каждом обзоре. Скорее сделать новую сущность и вытягивать отдельным запросом
        records = {
          formsRecords: defineFormsRecords(models)
          scored: {val: 0, tour: 0}
          topScoredTeams: {goals: 0, teams: []}
          lessConceededTeams: {goals: 10000, teams: []}
          goalscorers: {goals: 0, players: []}
          assistants: {assists: 0, players: []}
        }
        for tourNumber, summary of summaries
          summary.topScoredTeams = summary.topScoredTeams || []
          summary.lessConceededTeams = summary.lessConceededTeams|| []
          summary.topGoalscorers = summary.topGoalscorers || []
          summary.topAssistants = summary.topAssistants || []
          summary.formRecords = defineFormsRecords(models.filter((gm) -> gm.tourNumber <= tourNumber))

          if summary.scored > records.scored.val then records.scored = {val: summary.scored, tour: tourNumber}
          for team in summary.topScoredTeams
            if team.goals > records.topScoredTeams.goals
              records.topScoredTeams  = {goals: team.goals, teams: [{logo: team.logo, name: team.name, tour: tourNumber}]}
            else if team.goals is records.topScoredTeams.goals
              records.topScoredTeams.teams.push {logo: team.logo, name: team.name, tour: tourNumber}


          for team in summary.lessConceededTeams
            if team.goals < records.lessConceededTeams.goals
              records.lessConceededTeams  = {goals: team.goals, teams: [{logo: team.logo, name: team.name, tour: tourNumber}]}
            else if team.goals is records.lessConceededTeams.goals
              records.lessConceededTeams.teams.push {logo: team.logo, name: team.name, tour: tourNumber}

          for pl in summary.topGoalscorers
            if pl.goals > records.goalscorers.goals
              records.goalscorers  = {goals: pl.goals, players: [{logo: pl.teamLogo, name: pl.name, tour: tourNumber}]}
            else if pl.goals is records.lessConceededTeams.goals
              records.lessConceededTeams.teams.push {logo: pl.teamLogo, name: pl.name, tour: tourNumber}


          for pl in summary.topAssistants
            if pl.assists > records.assistants.assists
              records.assistants  = {assists: pl.assists, players: [{logo: pl.teamLogo, name: pl.name, tour: tourNumber}]}
            else if pl.assists is records.assistants.assists
              records.assistants.teams.push {logo: pl.teamLogo, name: pl.name, tour: tourNumber}


        for tourNumber, summary of summaries
          summary.records = records

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

  ##
  # получаем ключи, по которым можно запросить таблицы
  getSimpleTableKeys: (req, res) ->
    req.app.models.SimpleTable.find(leagueId: req.query.leagueId, {date: 1}, (err, models) ->
      dts = (m.date for m in models)
      dts.sort((a,b) ->
        dtA = a.split('/'); dtB = b.split('/')
        if dtA[2]*1000+dtA[1]*32+dtA[0] > dtB[2]*1000+dtB[1]*32+dtB[0] then return 1 else return -1
      )
      res.send dts
    )

  ##
  # простая таблица
  getSimpleTable: (req, res) ->
    Model = req.app.models.SimpleTable

    Model.findOne({leagueId: req.query.leagueId, date: req.query.dt}, (err, table) ->
      if err or !table
        res.status(400).send('no table found')
      else
        if req.query.compare_with_dt?
          Model.findOne({leagueId: req.query.leagueId, date: req.query.compare_with_dt}, (err, tableToCompare) ->
            if err or !tableToCompare
              res.status(400).send('no table to compare found')
            else

              for tmC in tableToCompare.teams
                for tm in table.teams
                  if tm._id is tmC._id
                    tm.diff = tmC.position - tm.position

              res.send table
          )
        else
          res.send table
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

  getGamePreview: (req, res) ->
    req.app.models.GamePreview.findOne(gameId: req.query.gameId, (err, model) ->
      res.send model
    )



module.exports = new TablesController()

