( ($) ->
  templates =
    field: (players) ->
      for pl in players
        pl.name = pl.name.toLowerCase()
        pl.firstName = pl.name.split(' ')[0]
        pl.firstName = pl.firstName.charAt(0).toUpperCase() + pl.firstName.slice(1)

        pl.lastName = pl.name.split(' ')[1]
        pl.fullName = pl.firstName + ' ' + pl.lastName.charAt(0).toUpperCase() + pl.lastName.slice(1)

      """
      <div id='field'>
  #{("<div class='player #{pl.position}'><img src='/#{pl.teamLogo}'><br>#{pl.firstName}</div>" for pl in players).join('')}
      </div>

      <table class="table table-striped" id="statsTable">
      <thead><th>Name</th><th>Pos</th><th>G</th><th>A</th></thead>
      #{("<tr><td><img src='/#{pl.teamLogo}'> #{pl.fullName}</td><td>#{pl.position}</td><td>#{pl.goals}</td><td>#{pl.assists}</td></tr>" for pl in players).join('')}
      </table>
"""

  $.fn.bestplayers = (leagueId, tourNumber) ->
    $.getJSON("/tables/best_players?leagueId=#{leagueId}&tourNumber=#{tourNumber}", (bp) =>
      @.html( templates.field(bp[0].players) )
    )

)(jQuery)
