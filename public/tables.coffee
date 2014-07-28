$ ->
  tablesCache = {}
  loadTables=  (leagueId) ->
    drawClimbingChart = (chart) ->
      $('#climbingChart').highcharts
        title: text: 20
        plotOptions: series: marker: enabled: false
        series: chart.series

    if  tablesCache[leagueId]?
      $('#simpletable').html(tablesCache[leagueId]['simpletable'])
      $('#chesstable').html(tablesCache[leagueId]['chesstable'])
      drawClimbingChart(tablesCache[leagueId]['climbingchart'])
      $('#goalscorers').html(tablesCache[leagueId]['goalscorers'])
    else
      tablesCache[leagueId] = {}

      $.getJSON('/tables/climbing_chart', {leagueId: leagueId}, (chart) ->
        tablesCache[leagueId]['climbingchart'] = chart.series
        drawClimbingChart(chart)
      )

      $.getJSON('/tables/simple_table', {leagueId: leagueId}, (table) ->
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
          formHtml = ''
          for res in team.form.slice(-5)
            formHtml +=  "<img src='http://icongal.com/gallery/image/"
            formHtml += (if res is 'W' then '134297/a.png' else if res is 'D' then '98963/a.png' else '134328/a.png')
            formHtml +=   "' height='16px' width='16px'>"

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
                <td>#{formHtml}</td>
            </tr>
                  """

          tablesCache[leagueId]['simpletable'] = html
          $('#simpletable').html(html)
      )

      $.getJSON('/tables/chess_table', {leagueId: leagueId}, (table) ->
          html = ''

          html += '<thead><th></th>'
          for team in table.teams
            if team.logo? and team.logo isnt ''
              html += "<th><img style='width: 20px; height: 20px' src='#{team.logo}'></th>"
            else
              html += "<th>#{team.name.charAt(0)}</th>"
          html += '</thead><tbody>'

          getResultByOpponentId = (results, id) ->
            res = (result for result in results when result.opponent is id)
            if res isnt [] then return res[0] else return null

          for team in table.teams
            html += "<tr><td>#{team.name}</td>"
            for opponent in table.teams
              if opponent._id is team._id
                html += '<td style="background-color: #f0f0f0"></td>'
              else
                html += '<td>'
                defineColor = (result) ->
                  if result.scored > result.conceeded then return 'green'
                  if result.scored is result.conceeded then return  '#black'
                  if result.scored < result.conceeded then return  'red'
                if homeResult = getResultByOpponentId(team.home, opponent._id)
                  html += "<span style='color: #{defineColor(homeResult)}; font-weight: 900'>"+homeResult.scored+':'+homeResult.conceeded+'</span>'
                if awayResult = getResultByOpponentId(team.away, opponent._id)
                  html += "<span style='color: #{defineColor(awayResult)}; font-weight: 900'>"+(
                    if homeResult? then ', ' else ''
                  )+awayResult.scored+':'+awayResult.conceeded+'</span>'

                html += '</td>'
            html += '</tr>'

          html += '</tbody>'

          tablesCache[leagueId]['chesstable'] = html
          $('#chesstable').html(html)
      )

      $.getJSON('/tables/top_goalscorers',  {leagueId: leagueId}, (table) ->
        console.log table.players
        html = '<table><thead><th>Name</th><th>Gls</th><th>Pld</th</thead><tbody>'
        for pl in table.players
          html += "<tr><td>#{pl.name}</td><td>#{pl.goals}</td><td>#{pl.played}</td></tr>"
        html += '</tbody></table>'

        tablesCache[leagueId]['goalscorers'] = html
        $('#goalscorers').html(html)

      )

  $.getJSON('/leagues', (leagues) ->
        html = ''
        for league in leagues
          html += "<option value='#{league._id}'>#{league.name}</option>"

        $('#leaguesSelect').html(html)

        $('#leaguesSelect').on('change', ->
          loadTables(@value)
        );

        $('#leaguesSelect').change()
    )