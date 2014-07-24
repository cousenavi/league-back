$ ->
  ##COMMON BLOCK##########

  exportData = ($el) ->
    data = {}
    $el.find('[data-value]').each((k, e) ->
      data[$(e).attr('data-value')] = $(e).val()
    )
    return data

  $('body').on('change', 'select', (e) ->
    name = $(e.target).find('option:selected').html()
    id = $(e.target).attr('id')
    $(e.target).parent().find("[data-target='#{id}']").val(name)
  )
  #########################


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
    protocol: (homeTeamPlayers, awayTeamPlayers) ->
      html = '<div class="row"><div class="col-xs-4 col-md-4 col-lg-4"><ul>'
      for pl in homeTeamPlayers
        html += "<li><b>#{pl.number}</b> #{pl.name}</li>"
      html += '</ul></div></div>'

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

    popup: (game, teams, places, referees) =>
      return """
 <div class="modal">
          <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h4 class="modal-title">
                        #{if game._id? then 'Редактирование матча' else 'Добавление матча'}
                    </h4>
                </div>
                <div class="modal-body">
                  <div class="row">
                   <div class="col-xs-6 col-md-6 col-lg-6">
                        <input type="hidden" data-target='homeTeamId' data-value='homeTeamName'>
                        <select class="form-control" id="homeTeamId" data-value="homeTeamId">
                          #{("<option id='#{team._id}'>#{team.name}</option>" for team in teams).join('')}
                        </select>
                    </div>
                    <div class="col-xs-6 col-md-6 col-lg-6" >
                        <input type="hidden" data-target='awayTeamId' data-value='awayTeamName'>
                        <select class="form-control" id="awayTeamId" data-value="awayTeamId">
                          #{("<option id='#{team._id}'>#{team.name}</option>" for team in teams).join('')}
                        </select>
                    </div>
                  </div><br>
                  <div class="row">
                    <div class="col-xs-4 col-md-4 col-lg-4">
                      <div class="input-group">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                        <input type="text" data-target='datetime' class='form-control'>
                      </div>
                    </div>
                    <div class="col-xs-4 col-md-4 col-lg-4" >
                      <div class="input-group">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-screenshot"></span></span>
                        <input type="hidden" data-target='placeId' data-value='placeName'>
                        <select class="form-control" data-value="placeId" id="placeId">
                            #{("<option id='#{place._id}'>#{place.name}</option>" for place in places).join('')}
                        </select>
                      </div>
                    </div>
                    <div class="col-xs-4 col-md-4 col-lg-4" >
                      <div class="input-group">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-user"></span></span>
                        <input type="hidden" data-target='refereeId' data-value='refereeName'>
                        <select class="form-control" id="refereeId" data-value="refereeId">
                            #{("<option id='#{ref._id}'>#{ref.name}</option>" for ref in referees).join('')}
                        </select>
                      </div>
                    </div>
                  </div><br>

                <div class="panel panel-default">
                  <div class="panel-body">
                        <div class="row">
                          <div class="col-xs-12 col-md-12 col-lg-12" style="text-align: center">
                              <h4>Результат</h4>
                          </div>
                        </div>
                        <div class="row">
                          <div class="col-xs-4 col-md-4 col-lg-4" ></div>
                          <div class="col-xs-2 col-md-2 col-lg-2" >
                            <select class="form-control" id="homeTeamScore" data-value="homeTeamScore">
                              <option></option>
                              #{("<option>#{hts}</option>" for hts in [0..50]).join('')}
                            </select>
                          </div>
                          <div class="col-xs-2 col-md-2 col-lg-2" >
                            <select class="form-control" id="homeTeamScore" data-value="awayTeamScore">
                              <option></option>
                              #{("<option>#{hts}</option>" for hts in [0..50]).join('')}
                            </select>
                          </div>
                          <div class="col-xs-4 col-md-4 col-lg-4" ></div>
                        </div>
                  </div>
                </div>


                <div class="panel panel-default">
                  <div class="panel-body">
                        <div class="row">
                          <div class="col-xs-12 col-md-12 col-lg-12" style="text-align: center">
                              <h4>
                                  Протокол
                                  <a id="addProtocol" class="btn btn-success">+</a>
                              </h4>
                              <div id='protocol'>
                              </div>
                          </div>
                        </div>
                  </div>
                </div>

                </div>
                <div class="modal-footer">
#{if !game._id? then '' else '<a class="btn btn-danger" id="btnDel" style="float:left">Удалить</a>' }
                  <a id="addPlayer" class="btn btn-success">Сохранить</a>
                </div>
            </div>
          </div>
        </div>
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

    $('#addBtn').on('click', (e) ->
      $(templates.popup(
        exportData(
          $(e.target).parent().parent()),
          (team for team in teams[0] when team.leagueId is $('#leaguesSelect').val()),
          places[0],
          referees[0])
      ).modal(show: true)
    )

    $('body').on('click', '#addProtocol', (e) ->
        console.log  model = exportData($(e.currentTarget).parent().parent().parent().parent().parent().parent())

        $.when(
          $.getJSON("/players?teamId=#{model.homeTeamId}")
          $.getJSON("/players?teamId=#{model.awayTeamId}")
        ).then((homePlayers, awayPlayers) ->
          $('#protocol').html(
            templates.protocol(homePlayers, awayPlayers)
          )
        )
    )
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
