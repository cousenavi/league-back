( ($) ->
  templates =
    playerAchievement: (pl) ->
      console.log pl
      html = ''
      if pl.goals then html += "&nbsp;<i class='ev goal'></i>#{pl.goals}"
      if pl.assists then html += "&nbsp;<i class='ev assist'></i>#{pl.assists}"
      if pl.star then html += "&nbsp;<i class='ev star'></i>"
      html

    player: (pl) ->
      """
        <tr>
            <td style='width: 25px'><i class='logo'><img  src="/#{pl.teamLogo}"/></i></td>
            <td>#{pl.firstName}</td>
            <td><i class='position'>#{pl.position}</i>#{templates.playerAchievement(pl)}</td>
        </tr>
"""

    field: (players, tourNumber) ->
      for pl in players
        pl.name = pl.name.toLowerCase()
        pl.firstName = pl.name.split(' ')[0]
        pl.firstName = pl.firstName.charAt(0).toUpperCase() + pl.firstName.slice(1)

        pl.lastName = pl.name.split(' ')[1]
        pl.fullName = pl.firstName + ' ' + pl.lastName.charAt(0).toUpperCase() + pl.lastName.slice(1)


      """
  <div id="prv">
    <div id='head'>
        <div id='leagueName'>Amateur Portugal League</div><div id='tourNumber'>Тур №#{tourNumber}</div>
    </div>

    <div id='field'>
        #{("<div class='chip #{pl.position}'><img src='/#{pl.teamLogo}'/></div>" for pl in players).join('')}
    </div>

    <div id='players'>
        <table>
        #{(templates.player(pl) for pl in players).join('')}
        </table>
        <div id='legend'>
           <i class='ev goal'></i> - гол <i class='ev assist'></i>- пас <i class='ev star'></i> - игрок матча

        </div>

    </div>

    <div style='clear:both'></div>


</div>
"""

#      """
#      <div id='field'>
#  #{("<div class='player #{pl.position}'><img src='/#{pl.teamLogo}'><br>#{pl.firstName}</div>" for pl in players).join('')}
#      </div>
#
#      <table class="table table-striped" id="statsTable">
#      <thead><th>Name</th><th>Pos</th><th>G</th><th>A</th></thead>
#      #{("<tr><td><img src='/#{pl.teamLogo}'> #{pl.fullName}</td><td>#{pl.position}</td><td>#{pl.goals}</td><td>#{pl.assists}</td></tr>" for pl in players).join('')}
#      </table>
#"""

  $.fn.bestplayers = (leagueId, tourNumber) ->
    $.getJSON("/tables/best_players?leagueId=#{leagueId}&tourNumber=#{tourNumber}", (bp) =>
      @.html( templates.field(bp[0].players, tourNumber) )
    )

)(jQuery)
