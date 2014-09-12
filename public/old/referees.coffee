$ ->
  $.getJSON('referees', (referees) ->

    for ref in referees
      html = """
                <tr id='#{ref._id}'>
                    <td  class="col-md-1">
<img src="#{ref.photo}" width="100px" height="100px">
                    </td>
                    <td  class="col-md-10">
                        <span style="font-size: 18pt">#{ref.name}</span><br>
                        обслужил игр: #{ref.serviced}<br>
                        средний рейтинг: #{ref.rating}
                    </td>
                    <td  class="col-md-1">
<button class="btn btn-block btn-danger" id="delRefBtn"><span class="glyphicon glyphicon-minus"></span></button>
                  </td>
                </tr>
"""

      $('#referees').append(
        html
      )

    $('#delRefBtn').click( (e) ->
      id = $(e.target).parent().parent().attr('id')
      $.post( '/referees/del',{_id: id}, -> location.reload())
    )
  )

  $('#addRefBtn').click( (e) ->
    ref = exportData(
      $(e.target).parent().parent()
    )
    $.post( '/referees/add',ref, -> location.reload())
  )

  exportData = ($el) ->
    data = {}
    $el.find('[data-value]').each((k, e) ->
      data[$(e).attr('data-value')] = $(e).val()
    )
    return data