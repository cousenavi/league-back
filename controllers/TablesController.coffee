class TablesController
  onResultAdded: (game) =>
    @updateSimleTable(game)

  updateSimleTable: (game, app) ->
    Game = app.models.Game
    Team = app.models.Team

    findByLeague = (model, leagueId) ->
      new Promise(resolve, reject) ->
        model.find(leagueId, (err, models) -> resolve(models))

    findByLeague(Game, game.leagueId).then((games) -> findByLeague(Team, game.leagueId).then((teams) ->
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
          goalsConceeded: 0

      for game in games
        records[game.homeTeamId].played += 1
        records[game.homeTeamId].goalsScored   += game.homeTeamScore
        records[game.homeTeamId].goalsConceded += game.awayTeamScore
        records[game.homeTeamId].won +=  (if game.homeTeamScore > game.awayTeamScore then 1 else 0)
        records[game.homeTeamId].draw +=  (if game.homeTeamScore == game.awayTeamScore then 1 else 0)
        records[game.homeTeamId].lost +=  (if game.homeTeamScore < game.awayTeamScore then 1 else 0)
        records[game.homeTeamId].score += (if game.homeTeamScore > game.awayTeamScore then 3 else
                                            if game.homeTeamScore == game.awayTeamScore then 1 else 0)
        records[game.awayTeamId].played += 1
        records[game.awayTeamId].goalsScored   += game.awayTeamScore
        records[game.awayTeamId].goalsConceded += game.homeTeamScore
        records[game.awayTeamId].won +=  (if game.homeTeamScore < game.awayTeamScore then 1 else 0)
        records[game.awayTeamId].draw +=  (if game.homeTeamScore == game.awayTeamScore then 1 else 0)
        records[game.awayTeamId].lost +=  (if game.homeTeamScore > game.awayTeamScore then 1 else 0)
        records[game.awayTeamId].score += (if game.homeTeamScore < game.awayTeamScore then 3 else
          if game.homeTeamScore == game.awayTeamScore then 1 else 0)

        records = (record for id, record of records)

        records.sort( (a, b) ->
          if a.score > b.score then return 1
          if a.score < b.score then return -1
          if (a.goalsScored - a.goalsConceded) > (b.goalsScored - b.goalsConceded) then return 1
          if (a.goalsScored - a.goalsConceded) < (b.goalsScored - b.goalsConceded) then return -1
          if a.goalsScored > b.goalsScored then return 1
          if a.goalsScored < b.goalsScored then return -1
          return 0
        )

        for record, position in records
          record.position = position

        Model = app.models.SimpleTable
        Model.findOneAndUpdate(leagueId: game.leagueId, teams: records)
    ))


  getSimpleTable: (req, res) ->
    Model = req.app.models.SimpleTable

    Model.find(req.query, (err, models) ->
      res.send models
    )

module.exports = new TablesController()

