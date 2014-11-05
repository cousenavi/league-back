( ($) ->

  sortByField = (fieldName) ->
    return (a,b) ->
       if a[fieldName] < b[fieldName] then return 1
       if a[fieldName] > b[fieldName] then return -1
       return 0

  templates =
    player: (pl, field) -> """
    <tr>
      <td><img src="/#{pl.teamLogo}"> #{pl.name}</td>
      <td>#{pl[field]}</td>
    </tr>
"""

    table: (players, fieldName, leagueName) ->

      pls = (templates.player(pl, fieldName) for pl in players).join('')

      html = """
<div id="prv">
  <div id='head'>
      <div id='leagueName'>#{leagueName}</div><div id='tourNumber'>#{fieldName}</div>
  </div>
  <table>
    #{pls}
  </table>
</div>
"""

  $.fn.listplayers = (leagueId, field) ->
    $.getJSON("/tables/top_players?field=#{field}",  {leagueId: leagueId}, (table) =>

      LIMIT = 15 #примерное количество игроков в таблице. Если будут с таким же показателем как у pl[LIMIT], то они тоже войдут

      filteredPlayers = table.players.sort(sortByField(field)).filter( (pl) ->
        pl[field] > 0 && pl[field] >= table.players[LIMIT][field]
      )

      @.html templates.table(filteredPlayers, field, 'Amateur Portugal League')
    )

)(jQuery)