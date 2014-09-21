$ ->
  tablesCache = {}
  loadTables=  (leagueId) ->
    drawClimbingChart = (chart) ->
      $('#climbingChart').highcharts
        chart: type: 'spline'
        title: text: 'Динамика набора очков командами'
        plotOptions:
            spline:
              lineWidth: 3
              marker: enabled: false
              states: hover: lineWidth: 5
        yAxis: title: {text: 'очки'}, floor: 0, gridLineWidth: 1, alternateGridColor: '#fcfcfc', gridLineDashStyle: 'Dash', allowDecimals: false
        xAxis: title: {text: 'матчи'}, floor: 0, allowDecimals: false
        series: chart.series.filter((v) -> (['Millwall', 'Reading', 'Leicester City', 'Wigan Athletics'].indexOf(v.name) isnt -1))



    if  tablesCache[leagueId]?
      $('#simpletable').html(tablesCache[leagueId]['simpletable'])
      $('#chesstable').html(tablesCache[leagueId]['chesstable'])
      drawClimbingChart(tablesCache[leagueId]['climbingchart'])
      $('#topplayers').html(tablesCache[leagueId]['topplayers'])
    else
      tablesCache[leagueId] = {}

      $.getJSON('/tables/climbing_chart', {leagueId: leagueId}, (chart) ->
        tablesCache[leagueId]['climbingchart'] = chart.series

        seriesColors = [
          '#FF523A',
          '#009900',
          '#000099',
          '#777777'
        ]

        '<div style="color: #ff0000"'>

        for cl, key in seriesColors
          chart.series[key].color = cl

        drawClimbingChart(chart)
      )

      $.getJSON('/tables/simple_table', {leagueId: leagueId}, (table) ->
        html = """
          <thead>
            <th>Pos</th>
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
            formHtml +=  "<img src='/img/circle/"
            formHtml += (if res is 'W' then 'green.png' else if res is 'D' then 'yellow.png' else 'red.png')
            formHtml +=   "' height='16px' width='16px'>"

          html += """
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
            html += """<tr><td>#{
                if team.logo? and team.logo isnt ''
                  "<img style='width: 20px; height: 20px' src='/#{team.logo}'>&nbsp;"
                else
                  ''
            }#{team.name}</td>"""
            for opponent in table.teams
              if opponent._id is team._id
                html += '<td style="background-color: #f0f0f0"></td>'
              else
                html += '<td>'
                defineColor = (result) ->
                  if result.scored > result.conceeded then return 'green'
                  if result.scored is result.conceeded then return  'black'
                  if result.scored < result.conceeded then return  'red'
                if homeResult = getResultByOpponentId(team.home, opponent._id)
                  html += "<span class = 'chesscore chesscore-#{defineColor(homeResult)}'>"+homeResult.scored+':'+homeResult.conceeded+'</span>'
                if awayResult = getResultByOpponentId(team.away, opponent._id)
                  html += "<span class = 'chesscore chesscore-#{defineColor(awayResult)}'>"+(
                    if homeResult? then '<br>' else ''
                  )+awayResult.scored+':'+awayResult.conceeded+'</span>'

                html += '<span style="color: white">'
                if !homeResult and !awayResult then html += '____'
                html += '</span>'

                html += '</td>'
            html += '</tr>'

          html += '</tbody>'

          tablesCache[leagueId]['chesstable'] = html
          $('#chesstable').html(html)
      )

      $.getJSON('/tables/top_players?field=goals',  {leagueId: leagueId}, (table) ->

          #todo вынести в отдельный виджет, полностью переработать
          arrow = "&nbsp;<span class='glyphicon glyphicon-arrow-down arrow' style='color:white'></span>"

          html = """
            <thead>
              <th>Name</th>
              <th data-sort="goals">G#{arrow}</th>
              <th data-sort="assists">A#{arrow}</th>
              <th data-sort="points">G+A#{arrow}</th>

              <th data-sort="yellow"><span class='glyphicon glyphicon-book' style="color:yellow"></span>#{arrow}</th>
              <th data-sort="red"><span class='glyphicon glyphicon-book' style="color:red"></span>#{arrow}</th>
              <th data-sort="played">GP#{arrow}</th>
            </thead><tbody>
  """

  #        <th data-sort="stars"><span class='glyphicon glyphicon-star'></span>#{arrow}</th>

          fillTable = (sortOrder) ->
            sortByFields = (fieldNames) ->
              return (a,b) ->
                for fieldName, order of fieldNames
                  if a[fieldName] < b[fieldName] then return 1*order
                  if a[fieldName] > b[fieldName] then return -1*order
                return 0

                #todo исправить этот говнокод ужасный
            sort = {}; sort[sortOrder] = 1; sort['played'] = -1;
            table.players.sort(sortByFields(sort))
            html = ''
            for pl in table.players
              html += """
                <tr>
                  <td>#{if pl.teamLogo then "<img style='width: 20px; height: 20px' src='/#{pl.teamLogo}'>&nbsp;" else "" }#{pl.name}</td>
                  <td>#{pl.goals}</td>
                  <td>#{pl.assists}</td>
                  <td>#{pl.points}</td>
                  <td>#{pl.yellow}</td>
                  <td>#{pl.red}</td>
                  <td>#{pl.played}</td>
                </tr>
    """
  #            <td>#{pl.stars}</td>

            return html


          html += fillTable('goals')
          html += '</tbody>'

          tablesCache[leagueId]['topplayers'] = html
          $('#topplayers').html(html)

          $('#topplayers').on({
            mouseover: ->
              if (index =  $(@).index()) > 0
                $(@).parent().parent().parent().find('tbody tr').each(->
                  $(@).find("td:eq(#{index})").addClass('active')
                )
            mouseleave: ->
              $(@).parent().parent().parent().find('tbody td').each(-> $(@).removeClass('active'))
            click: ->
              if (index =  $(@).index()) > 0
                $(@).parent().parent().find('.arrow').each(-> $(@).css(color: 'white'))
                $(@).find('.arrow').css(color: 'green')
                $('#topplayers tbody').html( fillTable($(@).attr('data-sort')))
          }, 'th')
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