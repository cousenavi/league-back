$ ->
  $.getJSON '/places', (places) ->
    for place in places
       html = """
                <tr id='#{place._id}'>
                  <td class="col-md-11">
                    <span style="font-size: 18pt">#{place.name}</span>
                    <br>#{place.address}
                  </td>
                  <td class="col-md-1">
                    <button class="btn btn-block btn-danger" id="delBtn"><span class="glyphicon glyphicon-minus"></span></button>
                  </td>
                </tr>
"""

       $('#list').append(
         html
       )

       $('#delBtn').click( (e) ->
         id = $(e.target).parent().parent().attr('id')
         $.post( '/places/del',{_id: id}, -> location.reload())
       )

  $('#addBtn').click( (e) ->
    console.log model = exportData(      $(e.target).parent().parent().parent()     )
    $.post( '/places/add',model, -> location.reload())
  )

  exportData = ($el) ->
    data = {}
    $el.find('[data-value]').each((k, e) ->
      data[$(e).attr('data-value')] = $(e).val()
    )
    return data