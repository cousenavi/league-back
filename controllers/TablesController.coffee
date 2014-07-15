class TablesController
  onResultAdded: (game) =>
    @updateSimleTable(game)

  updateSimleTable: (game) =>
    Game = @app.models.Game
    Team = @app.models.Team

    findByLeague = (model, leagueId, resolve) ->
        model.find(leagueId: leagueId, (err, models) -> resolve(models))

    findByLeague(Game, game.leagueId, (games) => findByLeague(Team, game.leagueId, (teams) =>

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
        console.log model
        if  model?
          Model.update({_id: model._id}, teams: records, (err, num) -> console.log err, num)
        else
          (new Model(leagueId: game.leagueId, teams: records)).save()
      )
      Model.findOneAndUpdate(leagueId: game.leagueId, teams: records)

      console.log " "
    ))


  getSimpleTable: (req, res) ->
    Model = req.app.models.SimpleTable

    Model.findOne(req.query, (err, model) ->
      res.send model
    )

module.exports = new TablesController()

