class RefereeApi
  login: (req, res) =>
    req.app.models.Referee.findOne({login: req.login, password: req.password}, (err, model) ->
      console.log model
    )

    res.send @getMatches(req, res)

  matches: (req, res) =>
    res.send @getMatches(req, res)

  getMatches: (req, res) ->
    req.app.models.Game.find(
      {refereeId: req.session.refereeId, ended: false}
    )

    [{_id: '123', homeTeamName: 'Millwall', awayTeamName: 'Wimbledon', date: '2015-01-01', time: '12:00', placeName: 'Прага'}]

  game: (req, res) ->
    res.send {
      homeTeam:
        name: 'Millwall'
        players: {
          'ac132b8f':  {'number': 8, 'name': 'AVETISOV FEDOR'}
          'ac132b80':  {'number': 15, 'name': 'BENIKSOV VLADIMIR'}
        }
      awayTeam:
        name: 'Wimbledon'
        players: {
          'ac132b8q':  {'number': 13, 'name': 'MAKSMOV EUGENY'}
        }
    }

  logout: (req, res) ->
    res.send('ok')


module.exports = new RefereeApi()

