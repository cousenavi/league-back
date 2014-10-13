$ ->
  $.getJSON('/leagues', (leagues) ->
    for leg in leagues

      imgsrc = if leg.logo? then leg.logo else ''

      html = """
                <tr id='#{leg._id}'>
                    <td  class="col-md-1">
<img src="#{imgsrc}" width="100px" height="100px">
                    </td>
                    <td  class="col-md-10">
                        <span style="font-size: 18pt">#{leg.name}</span><br>
                    </td>
                    <td  class="col-md-1">
<button class="btn btn-block btn-danger delBtn" ><span class="glyphicon glyphicon-minus"></span></button>
                    </td>
                </tr>
"""

      $('#list').append(
        html
      )

    $('.delBtn').click( (e) ->
        id = $(e.target).parent().parent().attr('id')
        $.post( '/leagues/del',{_id: id}, -> location.reload())
    )
  )

  $('#addBtn').click( (e) ->
    console.log model = exportData(      $(e.target).parent().parent().parent()     )

    $.post( '/leagues/add',model, -> location.reload())
  )

  exportData = ($el) ->
    data = {}
    $el.find('[data-value]').each((k, e) ->
      data[$(e).attr('data-value')] = $(e).val()
    )
    return data