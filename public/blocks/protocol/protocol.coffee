( ($) ->
  templates =
    protocol: (gm, homePl, awayPl) ->
      gm.leagueName = gm.leagueName || 'Amateurs Portugal League'


      """
<div class='statsWrap'>
  <div id='head'>
      <div id='leagueName'>Amateur Portugal League</div><div id='tourNumber'>тур №9</div>
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
<br><br><br>
<table id="signs">
<tr><td>________________________</td><td>________________________</td><td>________________________</td></tr>
<tr><td>главный судья</td><td>капитан #{gm.homeTeamName}</td><td>капитан #{gm.awayTeamName}</td></tr>
</table>
  <div id='foot'>
            <div id='date'>#{gm.date}</div>
            <div id='time'>#{gm.time}</div>
            <div id='place'>стадион "#{gm.placeName}"</div>
  </div>
  </div>
"""


  $.fn.protocol = (leagueId) ->
    formatPlayersNames = (players) ->
      for pl in players
        pl.name = pl.name.toLowerCase()

    $.getJSON('/games?leagueId=54009eb17336983c24342ed9&ended=false', (games) =>
      for gm in games
          $.when(
            $.getJSON("/players?teamId=#{gm.homeTeamId}")
            $.getJSON("/players?teamId=#{gm.awayTeamId}")
          ).then( (homePlayers, awayPlayers) =>
            formatPlayersNames(homePlayers[0])
            formatPlayersNames(awayPlayers[0])
            @.html templates.protocol(gm, homePlayers[0], awayPlayers[0])
          )
    )
)(jQuery)