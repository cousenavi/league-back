$ ->
  templates.game = (game) ->
    formatPlname = (pl) ->
      pl.name = pl.name.split(' ')[0].toLowerCase()
      pl.name = pl.name.charAt(0).toUpperCase() + pl.name.slice(1)

    formatPlname(pl) for pl in game.homeTeamPlayers
    formatPlname(pl) for pl in game.awayTeamPlayers

    html = "<h3>#{game.homeTeamName} - #{game.awayTeamName} #{game.homeTeamScore}:#{game.awayTeamScore}</h3>"
    html += "<b>#{game.homeTeamName}: </b>"
    html += "<br><b>Голы: </b>"
    html += ("##{pl.number} #{pl.name} #{if pl.goals > 1 then "(x#{pl.goals})" else ''} "for pl in game.homeTeamPlayers when pl.goals > 0).join(', ')
    html += "<br><b>Передачи: </b>"
    html += ("##{pl.number} #{pl.name} #{if pl.assists > 1 then "(x#{pl.assists})" else ''} "for pl in game.homeTeamPlayers when pl.assists > 0).join(', ')
    html += "<br><b>Карточки: </b>"
    html += ("##{pl.number} #{pl.name} (#{if pl.yellow is '1' then 'жк' else if pl.yellow is '2' then '2жк' else ''} #{if pl.red then 'кк' else ''})  "for pl in game.homeTeamPlayers when pl.yellow > 0 or pl.red > 0).join(', ')
    html += "<br><b>Игравшие: </b>"
    html += ("##{pl.number} #{pl.name}" for pl in game.homeTeamPlayers).join(', ')
    html += "<br><br><b>#{game.awayTeamName}: </b>"
    html += "<br><b>Голы: </b>"
    html += ("##{pl.number} #{pl.name} #{if pl.goals > 1 then "(x#{pl.goals})" else ''} "for pl in game.awayTeamPlayers when pl.goals > 0).join(', ')
    html += "<br><b>Передачи: </b>"
    html += ("##{pl.number} #{pl.name} #{if pl.assists > 1 then "(x#{pl.assists})" else ''} "for pl in game.awayTeamPlayers when pl.assists > 0).join(', ')
    html += "<br><b>Карточки: </b>"
    html += ("##{pl.number} #{pl.name} (#{if pl.yellow is '1' then 'жк' else if pl.yellow is '2' then '2жк' else ''} #{if pl.red then 'кк' else ''})  "for pl in game.awayTeamPlayers when pl.yellow > 0 or pl.red > 0).join(', ')
    html += "<br><b>Игравшие: </b>"
    html += ("##{pl.number} #{pl.name}" for pl in game.awayTeamPlayers).join(', ')


  #==============================================================++#

  user = localStorageRead('user')
  if !user? then location.href = '/admin'
  if user.role is 'root' then location.href = '/admin'
  if user.role is 'Captain' then location.href = '/admin'
  if user.role is 'Head'

    gameId = location.search.substr(1)
    $.getJSON("/games/#{gameId}", (game) ->
      console.log game
      $('#container').html templates.game(game)
    )


