( ($) ->

#------------------------------------------------------------------------------------------------#
  templates =
  #--
    table: (rows) ->
      """
        <table class="table"><thead>#{templates.head()}</thead><tbody>#{rows.join('')}</tbody></table>
"""
  #--
    head: () ->
       "<th>Pos</th>
        <th>Team</th>
        <th>GP</th>
        <th>W</th>
        <th>D</th>
        <th>L</th>
        <th>F</th>
        <th>A</th>
        <th>GD</th>
        <th>PTS</th>
        <th>LAST 5</th>"
  #--
    row: (team) ->
      formHtml = ''
      for res in team.form.slice(-5)
        formHtml +=  "<img src='/img/circle/"
        formHtml += (if res is 'W' then 'green.png' else if res is 'D' then 'yellow.png' else 'red.png')
        formHtml +=   "' height='16px' width='16px'>"

      html = """
              <tr>
                <td>#{team.position}</td>
                <td>#{
                    if team.logo? and team.logo isnt ''
                      "<img style='width: 20px; height: 20px' src='/#{team.logo}'>&nbsp;"
                    else
                      ''
                  }#{team.name}</td>
                <td>#{team.played}</td>
                <td>#{team.won}</td>
                <td>#{team.draw}</td>
                <td>#{team.lost}</td>
                <td>#{team.goalsScored}</td>
                <td>#{team.goalsConceded}</td>
                <td>#{team.goalsScored - team.goalsConceded}</td>
                <td>#{team.score}</td>
                <td>#{formHtml}</td>
            </tr>
                  """

  #------------------------------------------------------------------------------------------------#

  $.fn.table = (leagueId) ->
    $.getJSON("/tables/simple_table?leagueId=#{leagueId}", (table) =>
      rows = (templates.row(team) for team in table.teams)
      @.html(templates.table(rows))
    )

)(jQuery)
