$ ->
  $.getJSON('/leagues', (leagues) ->
    $('#leagues').typeahead({
      source: leagues
      matcher: (league) -> (league.name.indexOf(@query) > -1)
      updater: (league) ->
        @$element.parent().find("[data-value='leagueId']").attr('value', league._id)
        league.name
      sorter: (items) -> return items
      highlighter: (item) -> return item.name
    });
  )

  $.getJSON '/teams', (teams) ->
    for team in teams
       html = """
                <tr id='#{team._id}'>
                  <td class="col-md-1">
                    <img src="#{team.logo}" width="50px" height="50px">
                  </td>
                  <td class="col-md-10">
                    <span style="font-size: 18pt">#{team.name}</span>
                    <br><b>Лига:</b> #{team.leagueName}
                  </td>
                  <td class="col-md-1">
                    <button type="button" class="close" id="delBtn">×</button>
                  </td>
                </tr>
"""

       $('#list').append(
         html
       )

       $('#delBtn').click( (e) ->
         id = $(e.target).parent().parent().attr('id')
         $.post( '/teams/del',{_id: id}, -> location.reload())
       )

  $('#addBtn').click( (e) ->
    console.log model = exportData(      $(e.target).parent().parent().parent()     )
    $.post( '/teams/add',model, -> location.reload())
  )

  exportData = ($el) ->
    data = {}
    $el.find('[data-value]').each((k, e) ->
      data[$(e).attr('data-value')] = $(e).val()
    )
    return data