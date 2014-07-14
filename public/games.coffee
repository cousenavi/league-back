$ ->
  typeaheadParams =
    matcher: (item) ->
     item.name.toLowerCase().indexOf(@query.toLowerCase()) > -1
    updater: (item) ->
      item.name
    sorter: (items) -> return items
    highlighter: (item) -> return item.name

  selectTypeahead = (entity) ->
    new Promise (resolve, reject) ->
      $.getJSON "/#{entity}", (models) ->
        $("##{entity}").typeahead(  $.extend( typeaheadParams, {
          source: models
          updater: (item) ->
            resolve(item)
            item.name
        }))

  exportData = ($el) ->
    data = {}
    $el.find('[data-value]').each((k, e) ->
      data[$(e).attr('data-value')] = $(e).val()
    )
    return data


  selectTypeahead('leagues').then( (league) ->

    $('#addBtn').click( (e) ->
      console.log model = exportData(      $(e.target).parent().parent().parent()     )
      model.leagueId = league._id
      $.post( '/games/add',model, -> location.reload())
    )

    $.getJSON "/teams?leagueId=#{league._id}", (teams) ->
      $("[data-value='homeTeamName']").typeahead(  $.extend( typeaheadParams, {
            source: teams
            updater: (item) ->
              @$element.parent().find("[data-value='homeTeamId']").attr('value', item._id)
              item.name
          }))

      $("[data-value='awayTeamName']").typeahead(  $.extend( typeaheadParams, {
        source: teams
        updater: (item) ->
          @$element.parent().find("[data-value='awayTeamId']").attr('value', item._id)
          item.name
      }))

    $.getJSON "/places", (places) ->
      $("[data-value='placeName']").typeahead(  $.extend( typeaheadParams, {
        source: places
        updater: (item) ->
          @$element.parent().find("[data-value='placeId']").attr('value', item._id)
          item.name
      }))

    $.getJSON "/referees", (referees) ->
      $("[data-value='refereeName']").typeahead(  $.extend( typeaheadParams, {
        source: referees
        updater: (item) ->
          @$element.parent().find("[data-value='refereeId']").attr('value', item._id)
          item.name
      }))


    $.getJSON "/games?leagueId=#{league._id}", (games) ->
      for game in games

        blockView =  (game) ->
          if (game.homeTeamScore?)
            ''
          else
            """
<div>
 <input type="hidden" value="#{game._id}" data-value='_id'>
Результат:
<input type="text"  data-value="homeTeamScore" style="width: 30px">:
<input type="text"  data-value="awayTeamScore" style="width: 30px">
<button class="btn btn-block btn-success" id="addResultBtn" style="display: inline;  width: 30px">
  <span class="glyphicon glyphicon-plus"></span>
</button>
</div>
"""

        html = """
                  <tr id='#{game._id}'>
                    <td class="col-md-11">
                      <span style="font-size: 18pt">#{game.homeTeamName} - #{game.awayTeamName}  #{if game.homeTeamScore? then game.homeTeamScore+' - '+game.awayTeamScore  else ''}</span><br>
                      #{game.datetime} #{game.placeName} <br>
                      Судья: #{game.refereeName}<br>
                      #{blockView(game)}
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
          $.post( '/games/del',{_id: id}, -> location.reload())
        )

        $('#addResultBtn').click (e) ->
          console.log model = exportData( $(e.target).parent() )
          $.post( 'games/upd', model, -> location.reload())

  )

  $("[data-value='datetime']").datetimepicker(
    minuteStepping: 15
    minDate: new Date()
    showToday: false
  )

