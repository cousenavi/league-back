( ($) ->
  templates =
    body: (sortOrder, players) ->
      sortByFields = (fieldNames) ->
        return (a,b) ->
          for fieldName, order of fieldNames
            if a[fieldName] < b[fieldName] then return 1*order
            if a[fieldName] > b[fieldName] then return -1*order
          return 0

      #todo исправить этот говнокод ужасный
      sort = {}; sort[sortOrder] = 1; sort['played'] = -1;
      filteredPlayers = players.sort(sortByFields(sort)).filter( (pl) -> pl[sortOrder] > 0)
      html = ''
      for pl in filteredPlayers
        html += """
                    <tr>
                      <td>
    #{if pl.teamLogo then "<img style='width: 20px; height: 20px' src='/#{pl.teamLogo}'>&nbsp;" else "" }#{pl.name}</td>
                      <td #{if sortOrder is 'goals' then "class='active'" else ''}> #{pl.goals}</td>
                      <td #{if sortOrder is 'assists' then "class='active'" else ''}>#{pl.assists}</td>
                      <td #{if sortOrder is 'points' then "class='active'" else ''}>#{pl.points}</td>
                      <td #{if sortOrder is 'yellow' then "class='active'" else ''}>#{pl.yellow}</td>
                      <td #{if sortOrder is 'red' then "class='active'" else ''}>#{pl.red}</td>
                      <td #{if sortOrder is 'played' then "class='active'" else ''}>#{pl.played}</td>
                    </tr>
        """
      #            <td>#{pl.stars}</td>

      return html

    table: (sortOrder, body) ->
    #todo вынести в отдельный виджет, полностью переработать
      arrow = "&nbsp;<span class='glyphicon glyphicon-arrow-down arrow' style='color: green'></span>"

      html = """
              <table id="topplayers" class="table table-striped">
              <thead>
                <th>Name</th>
                <th data-sort="goals">G#{if sortOrder is 'goals' then arrow else ''}</th>
                <th data-sort="assists">A#{if sortOrder is 'assists' then arrow else ''}</th>
                <th data-sort="points">G+A#{if sortOrder is 'points' then arrow else ''}</th>

                <th data-sort="yellow"><span class='glyphicon glyphicon-book' style="color:yellow"></span>
                  #{if sortOrder is 'yellow' then arrow else ''}</th>
                <th data-sort="red"><span class='glyphicon glyphicon-book' style="color:red"></span>
                  #{if sortOrder is 'red' then arrow else ''}</th>
                <th data-sort="played">GP#{if sortOrder is 'played' then arrow else ''}</th>
              </thead><tbody>
     """

      #        <th data-sort="stars"><span class='glyphicon glyphicon-star'></span>#{arrow}</th>
      html += body
      html += '</tbody></table>'
      html

  $.fn.listplayers = (leagueId, field) ->

    $.getJSON("/tables/top_players?field=#{field}",  {leagueId: leagueId}, (table) =>

      body = templates.body(field, table.players)
      @.html( templates.table(field, body) )
    )


)(jQuery)