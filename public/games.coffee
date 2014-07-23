$ ->

  exportData = ($el) ->
    data = {}
    $el.find('[data-value]').each((k, e) ->
      data[$(e).attr('data-value')] = $(e).val()
    )
    return data

  formatDatetime=  (datetime) =>
        date = new Date(datetime)
        date.month = ->
          m = @getMonth()
          m++
          if m < 10 then m = '0'+m
          return ''+m
        date.minutes = ->
          m = @getMinutes()
          if m < 10 then m = '0'+m
          return ''+m

        return date.getDate()+'.'+(date.month())+' '+date.getHours()+':'+date.minutes()

  templates =

    game: (game) =>
      return """
        <tr>
          <input type='hidden' value="#{game._id}" data-value="_id">
          <input type='hidden' value="#{game.homeTeamName}" data-value="homeTeamName">
          <input type='hidden' value="#{game.homeTeamId}" data-value="homeTeamId">
          <input type='hidden' value="#{game.awayTeamName}" data-value="awayTeamName">
          <input type='hidden' value="#{game.awayTeamId}" data-value="awayTeamId">
          <input type='hidden' value="#{game.placeId}" data-value="placeId">
          <input type='hidden' value="#{game.placeName}" data-value="placeName">
          <input type='hidden' value="#{game.refereeName}" data-value="refereeName">
          <input type='hidden' value="#{game.refereeId}" data-value="refereeId">

          <td>
            <span style="font-size:14pt">#{game.homeTeamName} - #{game.awayTeamName}</span>
            <span style="float: right">#{game.placeName}, #{formatDatetime(game.datetime)}</span>

          </td>
        </tr>
              """

    popup: (game) =>
      return """
"""

  loadGamesHtml = (leagueId) ->
    @cache = {} if !@cache?
    return new Promise((resolve, reject) =>
      if @cache[leagueId]
        resolve(@cache[leagueId])
      else
        $.getJSON("/games?leagueId=#{leagueId}", (games) =>
          html = (templates.game(gm) for gm in games).join('')
          @cache[leagueId] = html
          resolve(@cache[leagueId])
      )
    )

  $.when(
    $.getJSON('/leagues')
    $.getJSON('/teams')
    $.getJSON('/places')
    $.getJSON('/referees')
  ).then((leagues, teams, places, referees) ->
    $('#leaguesSelect').html(
      ("<option value='#{league._id}'>#{league.name}</option>" for league in leagues[0]).join('')
    ).on('change', ->
      $('#list').html(
        loadGamesHtml(@value).then((html) ->
          $('#list').html(html)
        )
      )
    ).change()
  )

#
#  loadGames = (leagueId) ->
#    $("[data-value='homeTeamId']").val(leagueId)
#
#    $.getJSON "/teams?leagueId=#{leagueId}", (teams) ->
#      html = ''
#      for team in teams
#        html += "<option value='#{team._id}'>#{team.name}</option>"
#      #todo навешивание колбеков отсюда убрать!!
#      $("[data-value='homeTeamId']").html(html).on('change', ->
#        $("[data-value='homeTeamName']").val($("option:selected", @).html()))
#      $("[data-value='awayTeamId']").html(html).on('change', ->
#        $("[data-value='awayTeamName']").val($("option:selected", @).html()))
#
#    $.getJSON "/places", (places) ->
#      html = ''
#      for place in places
#        html += "<option value='#{place._id}'>#{place.name}</option>"
#      $("[data-value='placeId']").html(html).on('change', ->
#        $("[data-value='placeName']").val($("option:selected", @).html()))
#
#    $.getJSON "/referees", (referees) ->
#      html = ''
#      for ref in referees
#        html += "<option value='#{ref._id}'>#{ref.name}</option>"
#      $("[data-value='refereeId']").html(html).on('change', ->
#        $("[data-value='refereeName']").val($("option:selected", @).html()))
#
#
#    $("[data-value='datetime']").datetimepicker(
#      minuteStepping: 15
#      minDate: new Date()
#      showToday: false
#    )
#
#    $.getJSON "/games?leagueId=#{leagueId}", (games) ->
#
#      html = ''
#      for game in games
#        blockView =  (game) ->
#          if (game.homeTeamScore?) then '' else  """
#<div>
#  <input type="hidden" value="#{game._id}" data-value='_id'>
#  Результат:
#  <input type="text"  data-value="homeTeamScore" style="width: 30px">:
#  <input type="text"  data-value="awayTeamScore" style="width: 30px">
#  <button class="btn btn-block btn-success" id="addResultBtn" style="display: inline;  width: 30px">
#    <span class="glyphicon glyphicon-plus"></span>
#  </button>
#</div>
#"""
#
#        html += """
#                  <tr id='#{game._id}'>
#                    <td class="col-md-11">
#                      <span style="font-size: 18pt">#{game.homeTeamName} - #{game.awayTeamName}  #{if game.homeTeamScore? then game.homeTeamScore+' - '+game.awayTeamScore  else ''}</span><br>
#                      #{game.datetime} #{game.placeName} <br>
#                      Судья: #{game.refereeName}<br>
#                      #{blockView(game)}
#                    </td>
#
#
#                    <td class="col-md-1">
#                      <button class="btn btn-block btn-danger" id="delBtn"><span class="glyphicon glyphicon-minus"></span></button>
#                    </td>
#                  </tr>
#        """
#
#      $('#list').html(html)
#
#
#
#  $.getJSON('leagues', (leagues) ->
#    html = ''
#    for league in leagues
#      html += "<option value='#{league._id}'>#{league.name}</option>"
#
#    $('#leaguesSelect').html(html)
#
#    $('#leaguesSelect').on('change', ->
#      loadGames(@value)
#    );
#
#    $('#delBtn').click( (e) ->
#      id = $(e.target).parent().parent().attr('id')
#      $.post( '/games/del',{_id: id}, -> location.reload())
#    )
#    $('#addBtn').click( (e) ->
#      console.log model = exportData(      $(e.target).parent().parent().parent()     )
##      $.post( '/games/add',model, -> location.reload())
#    )
#
#    $('#leaguesSelect').change()
#  )
