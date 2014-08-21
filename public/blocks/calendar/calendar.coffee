( ($) ->
  templates =
    table: (rows) -> 
      """
        <table class="table">#{rows.join('')}</table>
"""

    row: (game) ->
      computePlayers =  (protocol) ->
        players = []
        for pl in protocol
          if pl.goals > 0 then players.push {name: pl.name, goals: pl.goals}
        players.sort((a, b) -> if a.goals < b.goals then 1 else -1 )
        formattedPlayers = ""
        for pl, key in players
          pl.name = pl.name.split(' ')[0].toLowerCase()
          pl.name = pl.name.charAt(0).toUpperCase() + pl.name.slice(1)
          formattedPlayers += ' '+pl.name
          if pl.goals > 1 then formattedPlayers += "(#{pl.goals})"
          if key < players.length - 1 then formattedPlayers += ','


        "<div class='players'>#{formattedPlayers}</div>"

      """
        <tr><td><img src ="#{game.homeTeamLogo}"></td>
            <td>#{game.homeTeamName}
              #{if game.homeTeamPlayers? then computePlayers(game.homeTeamPlayers) else ''}
            </td>
            <td class="score"> #{
              if game.homeTeamScore?
               "#{game.homeTeamScore} - #{game.awayTeamScore}"
              else
                (if game.time? then game.date+" "+game.time else game.date)
            } </td>
            <td>#{game.awayTeamName}</td><td><img src ="#{game.awayTeamLogo}"></td></tr>
"""


  $.fn.calendar = (leagueId, startDate, endDate) ->
    if !leagueId || !startDate || !endDate then throw 'not enough parameters'

    $.getJSON("/games/?leagueId=#{leagueId}&startDate=#{startDate}&endDate=#{endDate}&showPlayers=1")
      .then((games) =>
        @.html(templates.table(
          (templates.row(gm) for gm in games)
        ))
      )
)(jQuery)
