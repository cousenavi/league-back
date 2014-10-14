( ($) ->
  templates =
    table: (rows) ->
      """
        #{rows.join('')}
"""

    stats: (stats) -> """
      <table class="table table-striped summary">
        <thead>
        <th></th>
        <th>в туре</th>
        <th>рекорд</th>
        </thead>
        <tbody>
          <tr><td><b>Сыграно матчей</b></td><td>#{stats.played}</td><td></td></tr>
          <tr><td><b>Забито голов</b></td><td>#{stats.scored}</td><td>#{stats.records.scored.val} <span class="recordTour">(#{stats.records.scored.tour} тур)</span></td></tr>
          <tr><td><b>Показано жёлтых</b></td><td>#{stats.yellow}</td><td></td></tr>
          <tr><td><b>Показано красных</b></td><td>#{stats.red}</td><td></td></tr>
          <tr><td><b>Забили больше всех</b></td>
              <td>#{("<img src='/#{tm.logo}'> #{tm.name} (#{tm.goals})"for tm in stats.topScoredTeams).join(', ')}</td>
              <td>#{stats.records.topScoredTeams.goals}: #{("<img src='/#{tm.logo}'> #{tm.name} <span class='recordTour'>(#{tm.tour} тур)</span>"for tm in stats.records.topScoredTeams.teams).join(', ')}</td>
          </tr>
          <tr><td><b>Пропустили меньше всех</b></td>
              <td>#{("<img src='/#{tm.logo}' > #{tm.name} (#{tm.goals})"for tm in stats.lessConceededTeams).join(', ')}</td>
              <td>#{stats.records.lessConceededTeams.goals}: #{("<img src='/#{tm.logo}'> #{tm.name} <span class='recordTour'>(#{tm.tour} тур)</span>"for tm in stats.records.lessConceededTeams.teams).join(', ')}</td></tr>
          <tr><td><b>Самая грубая команда</b></td><td>#{("<img src='/#{tm.logo}' > #{tm.name} (#{tm.yellow} + #{tm.red})" for tm in stats.mostRudeTeams).join(', ')}</td><td></td></tr>
          <tr><td><b>Голеодор тура</b></td>
              <td>#{("<img src='/#{pl.teamLogo}'> #{pl.name} (#{pl.goals})"for pl in stats.topGoalscorers).join(', ')}</td>
              <td>#{stats.records.goalscorers.goals}: #{("<img src='/#{pl.logo}'> #{pl.name} <span class='recordTour'>(#{pl.tour} тур)</span>"for pl in stats.records.goalscorers.players).join(', ')}</td></tr>
          </tr>
          <tr><td><b>Ассистент тура</b></td>
              <td>#{("<img src='/#{pl.teamLogo}'> #{pl.name} (#{pl.assists})"for pl in stats.topAssistants).join(', ')}</td>
              <td>#{stats.records.assistants.assists}: #{("<img src='/#{pl.logo}'> #{pl.name} <span class='recordTour'>(#{pl.tour} тур)</span>"for pl in stats.records.assistants.players).join(', ')}</td></tr>
</tr>
          <tr><td><b>Серия побед</b></td><td></td><td></td></tr>
          <tr><td><b>Серия без поражений</b></td><td></td><td></td></tr>
          <tr><td><b>Голевая серия</b></td><td></td><td></td></tr>
        </tbody>
      </table>
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
        <div class="row match">
          <div class="col-xs-2 col-md-2 col-lg-2"><img src ="/#{game.homeTeamLogo}"></div>
          <div class="col-xs-3 col-md-3 col-lg-3 teamName">#{game.homeTeamName} #{if game.homeTeamPlayers? then computePlayers(game.homeTeamPlayers) else ''}</div>
          <div class="col-xs-2 col-md-2 col-lg-2 score">
            #{
              if game.homeTeamScore?
               "#{game.homeTeamScore} - #{game.awayTeamScore}"
              else
                (if game.time? then game.date+" "+game.time else game.date)
            }
          </div>
          <div class="col-xs-3 col-md-3 col-lg-3 teamName" >#{game.awayTeamName} #{if game.awayTeamPlayers? then computePlayers(game.awayTeamPlayers) else ''}</div>
          <div class="col-xs-2 col-md-2 col-lg-2"><img src ="/#{game.awayTeamLogo}"></div>
        </div><
"""

  $('body').on('click', '.summary tr', ->
    $(@).hide()
  )

  $.fn.calendar = (leagueId,tourNumber) ->
    $.getJSON("/games/?leagueId=#{leagueId}&showPlayers=1&tourNumber=#{tourNumber}", (games) =>
        @.html(templates.row(gm) for gm in games)
    )

  $.fn.stats = (leagueId, tourNumber) ->
    $.getJSON("/tables/tour_summary/?leagueId=#{leagueId}&tourNumber=#{tourNumber}", (stats) =>
      @.html templates.stats(stats)
    )
)(jQuery)
