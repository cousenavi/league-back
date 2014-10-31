( ($) ->
  templates =
    protocol: (gm, homePl, awayPl) ->
      gm.leagueName = gm.leagueName || 'Amateurs Portugal League'


      """
<div class="page">
<div class='statsWrap'>
  <div id='head'>
      <div id='leagueName'>Amateur Portugal League</div><div id='tourNumber'>тур №#{gm.tourNumber}</div>
  </div>
  <h1>#{gm.homeTeamName} - #{gm.awayTeamName}</h1>
  <div>Счёт матча:  ___ : ___  (после первого тайма: ___ : ___)</div><br>
  <table class="table">
  <thead>
    <th>#</th><th>имя</th><th>Г + П</th><th>Ж + К</th><th>З + З</th>
    <th>#</th><th>имя</th><th>Г + П</th><th>Ж + К</th><th>З + З</th>
  </thead>
  <tbody>
    #{("<tr #{if !homePl[i]? and !awayPl[i]? then 'style="height: 0;border: 0;"' else ''}><td>#{homePl[i]?.number || ''}</td><td>#{homePl[i]?.name || ''}</td><td></td><td></td><td></td><td>#{awayPl[i]?.number || ''}</td><td>#{awayPl[i]?.name || ''}</td><td></td><td></td><td></td></tr>" for i in [0..24]).join('') }
  </tbody>
  </table>
<span class="help">Г+П: гол + пас, Ж+К: карточки, И+И: игрок матча (выбор своих) + (выбор соперника)<br>
Примеры заполнения: 2+3; 1+0; 0+1</span>
<br><br><br><br>
<table id="signs">
<tr><td>__________________________</td><td>__________________________</td><td>____________________________</td></tr>
<tr><td>главный судья</td><td>капитан #{gm.homeTeamName}</td><td>капитан #{gm.awayTeamName}</td></tr>
</table>
  <div id='foot'>
            <div id='date'>#{gm.date}</div>
            <div id='time'>#{gm.time}</div>
            <div id='place'>стадион "#{gm.placeName}"</div>
  </div>
  </div></div>
"""


  $.fn.protocol = (leagueId) ->
    formatPlayersNames = (players) ->
      for pl in players
        pl.name = pl.name.toLowerCase()
        firstName = pl.name.split(' ')[0]
        firstName = firstName.charAt(0).toUpperCase() + firstName.slice(1)
        lastName = pl.name.split(' ')[1]
        lastName = lastName.charAt(0).toUpperCase() + lastName.slice(1)
        pl.name = firstName+' '+lastName
      players.sort((a,b) -> if a.number > b.number then 1 else -1 )

    $.getJSON('/games?leagueId=54009eb17336983c24342ed9&ended=false', (games) =>
      loadGames = (i) =>
          $.when(
            $.getJSON("/players?teamId=#{games[i].homeTeamId}")
            $.getJSON("/players?teamId=#{games[i].awayTeamId}")
          ).then( (homePlayers, awayPlayers) =>
            formatPlayersNames(homePlayers[0])
            formatPlayersNames(awayPlayers[0])
            @.append templates.protocol(games[i], homePlayers[0], awayPlayers[0])
            if games[i]? then loadGames(i+1)
          )
      if games[0]? then loadGames(0)
    )
)(jQuery)