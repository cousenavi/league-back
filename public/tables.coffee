$ ->
  $.getJSON('/tables/simple_table', {leagueId: '53c55cff737e7c9a0ef19cdd'}, (table) ->

     html = """
      <thead>
        <th>POS</th>
        <th>Team</th>
        <th>GP</th>
        <th>W</th>
        <th>D</th>
        <th>L</th>
        <th>F</th>
        <th>A</th>
        <th>GD</th>
        <th>PTS</th>
        <th>LAST 5</th>
      </thead>
"""

     for team in table.teams
      html += """
        <tr>
          <td>#{team.position}</td>
          <td>#{team.name}</td>
          <td>#{team.played}</td>
          <td>#{team.won}</td>
          <td>#{team.draw}</td>
          <td>#{team.lost}</td>
          <td>#{team.goalsScored}</td>
          <td>#{team.goalsConceded}</td>
          <td>#{team.goalsScored - team.goalsConceded}</td>
          <td>#{team.score}</td>
          <td></td>
        </tr>
"""

     $('#simpletable').append(html)
  )