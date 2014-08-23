class RefereeApi
  login: (req, res) ->
    res.send [{_id: '123', homeTeamName: 'Millwall', awayTeamName: 'Wimbledon', date: '2015-01-01', time: '12:00', placeName: 'Прага'}]

  game: (req, res) ->
    res.send {
      homeTeam:
        name: 'Millwall'
        players: {
          'ac132b8f':  [8, 'Avetisov']
          'ac132b80':  [15, 'Beniksov']
        }
      awayTeam:
        name: 'Wimbledon'
        players: {
          'ac132b8q':  [13, 'Mcsimov']
        }
    }


  logout: (req, res) ->
    res.send('ok')


module.exports = new RefereeApi()

