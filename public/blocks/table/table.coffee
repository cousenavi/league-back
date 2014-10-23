( ($) ->

#------------------------------------------------------------------------------------------------#
  templates =
  #--
    table: (rows, compareDt) ->
      """
        <table class="table"><thead>#{templates.head()}</thead><tbody>#{rows.join('')}</tbody></table>
        * - изменения позиций по сравнению с таблицей от #{compareDt}
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
    arrow: (team) ->
      if !team.diff?
        ''
      else
        d = team.diff
        arrowClass = (if d>2 then  'gv' else if d>0 then 'gd' else if d is 0 then 'yh' else if d > -2 then 'rd' else 'rv')
        "(<i class='arrow #{arrowClass}'></i>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{if d > 0 then '+' else ''}#{d})"

    row: (team) ->
      formHtml = ''
      for res in team.form.slice(-5)
        formHtml +=  "<img src='/img/circle/"
        formHtml += (if res is 'w' then 'green.png' else if res is 'd' then 'yellow.png' else 'red.png')
        formHtml +=   "' height='16px' width='16px'>"

      html = """
              <tr>
                <td><span class="position">#{team.position}</span>
                #{@arrow(team)}
                </td>
                <td>#{
                    if team.logo? and team.logo isnt ''
                      "<img class='logo' src='/#{team.logo}'>&nbsp;"
                    else
                      ''
                  }

                  <span class="name">#{team.name}</span></td>
                <td>#{team.played}</td>
                <td>#{team.won}</td>
                <td>#{team.draw}</td>
                <td>#{team.lost}</td>
                <td>#{team.scored}</td>
                <td>#{team.conceded}</td>
                <td>#{team.scored - team.conceded}</td>
                <td>#{team.score}</td>
                <td>#{formHtml}</td>
            </tr>
                  """

  #------------------------------------------------------------------------------------------------#

  $.fn.table = (leagueId, dt, compareWithDt) ->

    buildQuery =  ->
      query = '?leagueId='+leagueId
      if dt? then query += '&dt='+dt
      if compareWithDt? then query += '&compare_with_dt='+compareWithDt
      return query

    $.getJSON("/tables/simple_table"+buildQuery(), (table) =>
      rows = (templates.row(team) for team in table.teams)
      @.html(templates.table(rows, compareWithDt))
    )

)(jQuery)
