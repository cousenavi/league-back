##
# временный класс для рефакторинга модели игры
class GameAdapter
  
  toLocal: (serverModel) ->
    localModel = serverModel
    localModel.teams = [
      {_id: serverModel.homeTeamId, logo: serverModel.homeTeamLogo, name: serverModel.homeTeamName,        score: serverModel.homeTeamScore || 0, players: serverModel.homeTeamPlayers || [], refereeMark: serverModel.homeTeamRefereeMark
      },
      {_id: serverModel.awayTeamId, logo: serverModel.awayTeamLogo, name: serverModel.awayTeamName,        score: serverModel.awayTeamScore || 0, players: serverModel.awayTeamPlayers || [], refereeMark: serverModel.awayTeamRefereeMark
      }
    ]
    delete localModel.homeTeamId
    delete localModel.homeTeamName
    delete localModel.homeTeamLogo
    delete localModel.homeTeamScore
    delete localModel.homeTeamPlayers
    delete localModel.homeTeamRefereeMark
    delete localModel.awayTeamId
    delete localModel.awayTeamName
    delete localModel.awayTeamLogo
    delete localModel.awayTeamScore
    delete localModel.awayTeamPlayers
    delete localModel.awayTeamRefereeMark
    return serverModel
  
  toServer: (localModel) ->
    serverModel = localModel
    serverModel.homeTeamId = localModel.teams[0]._id
    serverModel.homeTeamName = localModel.teams[0].name
    serverModel.homeTeamLogo = localModel.teams[0].logo
    serverModel.homeTeamScore = localModel.teams[0].score
    serverModel.homeTeamPlayers = localModel.teams[0].players
    serverModel.homeTeamRefereeMark = localModel.teams[0].refereeMark
    serverModel.awayTeamId = localModel.teams[1]._id
    serverModel.awayTeamName = localModel.teams[1].name
    serverModel.awayTeamLogo = localModel.teams[1].logo
    serverModel.awayTeamScore = localModel.teams[1].score
    serverModel.awayTeamPlayers = localModel.teams[1].players
    serverModel.awayTeamRefereeMark = localModel.teams[1].refereeMark

    return serverModel

module.exports = GameAdapter
