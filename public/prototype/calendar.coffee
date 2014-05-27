render = (template, model) ->
  for key, value of model
    template = template.replace "%#{key}%", value
  template

extractValues = ($obj) ->
  model = {}
  $obj.find('[data-value]').each((idx, el) =>
    key   = $(el).attr('data-value')
    value =  if $(el).val() isnt '' then $(el).val() else $(el).html()
    model[key] = value
  )
  return model


$ ->
  gameRowHtml = '''
                <tr>
                    <td style="display: none" data-value="_id">%_id%</td>
                    <td data-value="tour">%tour%</td>
                    <td data-value="date">%date%</td>
                    <td data-value="homeTeam">%homeTeam%</td>
                    <td data-value="awayTeam">%awayTeam%</td>
                    <td></td>
                    <td><button class="btn btn-danger btn-block" id="delGameBtn"><span class="glyphicon glyphicon-minus"></span></button></td>
                </tr>
'''
  $.getJSON('/games', (data) ->
    for model in data
      $('#calendarBody').prepend( render(gameRowHtml, model) )

    $('#delGameBtn').click( (e) ->
      model = extractValues($(e.target).parent().parent().parent())
      $.post('/game_delete', model, -> location.reload())
    )

    $('#addGameBtn').click( (e) ->
      model = extractValues($(e.target).parent().parent().parent())
      $.post('/game_add', model, -> location.reload())
    )
  )



