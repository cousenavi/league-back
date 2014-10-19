( ($) ->

#------------------------------------------------------------------------------------------------#
  templates =
    #--
    table: (heads, rows) ->
      """
        <div id="chesswrapper"><table class="table"><thead><th></th>#{heads.join('')}</thead><tbody>#{rows.join('')}</tbody></table></div>
"""
    #--
    head: (teamLogo) ->
      "<th><img src='/#{teamLogo}'></th>"
    #--
    row: (team, cells) ->
      "<tr><td><img src='/#{team.logo}'>&nbsp;#{team.name}</td>#{cells.join('')}</tr>"
    #--
    cell: (team, gm) ->
      if team._id is gm.opponent
        '<td><img src="/leagues/portugal/logo/league.png"></td>'
      else
        html = ''
        for m in gm.matches
          color = (if m.scored > m.conceeded then 'green' else if m.scored < m.conceeded then 'red' else 'gray')
          html += "<div class='#{color}'>#{m.scored}:#{m.conceeded}</div>"
        "<td>#{html}</td>"
#------------------------------------------------------------------------------------------------#

  $.fn.chess = (leagueId) ->
    $.getJSON('/tables/chess_table', {leagueId: leagueId}, (table) =>

        heads = (templates.head(tm.logo) for tm in table.teams)

        console.log table.teams

        rows = (templates.row(tm, (templates.cell(tm, gm) for gm in tm.games)) for tm in table.teams )

        @.html(templates.table(heads, rows))
    )

)(jQuery)
