$ ->
  ##COMMON BLOCK##########

  exportData = ($el) ->
    data = {}
    $el.find('[data-value]').each( ->
      data[$(@).attr('data-value')] = $(@).val()
    )
    $el.find('[data-collection]').each(->
      key = $(@).attr('data-collection')
      data[key] = []
      $(@).find('[data-element]').each( ->
        obj = {}
        $(@).find('[data-atom]').each( ->
          obj[$(@).attr('data-atom')]  = $(@).val()
        )
        data[key].push(obj)
      )

    )
    return data

  $('body').on('change', 'select', (e) ->
    name = $(e.target).find('option:selected').html()
    id = $(e.target).attr('id')
    $(e.target).parent().find("[data-target='#{id}']").val(name)
  )
  #########################


  formatDatetime=  (datetime, mode = 'simple') =>
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

        if mode is 'simple'
          return date.getDate()+'.'+(date.month())+' '+date.getHours()+':'+date.minutes()
        if mode is 'extended'
          return date.month()+'/'+date.getDate()+'/'+date.getFullYear()+' '+date.getHours()+':'+date.minutes()



  templates =
    protocol: (homeTeamPlayers, awayTeamPlayers, game) ->
      findPlayedPlayer = (player) ->
        if !game? then return null
        if !game.homeTeamPlayers and !game.awayTeamPlayers then return null
        for pl in game.homeTeamPlayers.concat(game.awayTeamPlayers)
          if pl._id is player._id
            pl.goals = (if pl.goals > 0 then pl.goals else '')
            pl.assists = (if pl.assists > 0 then pl.assists else '')
            pl.goalsassists =  (if pl.goals + pl.assists then pl.goals+'/'+pl.assists else '')
            pl.yellow = (if pl.yellow > 0 then pl.yellow else '')
            pl.red = (if pl.red > 0 then pl.red else '')
            pl.yellowred = (if pl.yellow + pl.red then pl.yellow+'/'+pl.red else '')
            return pl

        return null

      buildTable = (players, label) ->
        html = '<div class="col-xs-6 col-md-6 col-lg-6">'
        html += "<table class='table table-hover' data-collection='#{label}'><thead ><th>#</th><th></th><th style='text-align: center'>г/п</th><th style='text-align: center'>ж/к</th><th><span class='glyphicon glyphicon-star' id='star'></span></th></thead><tbody>"
        for pl in players
          pd = findPlayedPlayer(pl)
          html += """
                <tr data-element #{if pd? then 'class="active"' else ''}>
                <input type='hidden' data-atom="_id" value="#{pl._id}">
                <input type='hidden' data-atom="name" value="#{pl.name}">
                <input type='hidden' data-atom="star" value="false">
                <input type='hidden' data-atom="played" value="#{if pd? then 'true' else 'false'}">

                <td><span  class='glyphicon glyphicon-ok' style='#{if pd? then '' else 'display:none;'} color:green' id="played"></span>&nbsp;&nbsp;<b">#{pl.number}</b></td><td >#{pl.name}</td>
                <td><input type="text" style="width:30px; text-align: center; background: #f5f5f5; border: 1px solid #f5f5f5; #{if pd? then '' else 'display:none;'}" value="#{if pd? then pd.goalsassists else ''}" data-atom="goalsassists"></td>
                <td><input type="text" style="width:30px; text-align: center; background: #f5f5f5; border: 1px solid #f5f5f5; #{if pd? then '' else 'display:none;'}  " value="#{if pd? then pd.yellowred else ''}" data-atom="yellowred"></td>
                <td><span  class='glyphicon glyphicon-star' style='#{if pd? and pd.star is 'true' then '' else 'display:none;'}' id="star"></span></td>
                </tr>
"""
        html += '</tbody></table></div>'
        return html

      html = '<div class="row">'+buildTable(homeTeamPlayers, 'homeTeamPlayers')+''+buildTable(awayTeamPlayers, 'awayTeamPlayers')+'</div>'

    game: (game) =>
      return """
        <tr>
          <input type='hidden' value="#{game._id}" data-value="_id">
          <input type='hidden' value="#{game.leagueId}" data-value="leagueId">
          <input type='hidden' value="#{game.tourNumber}" data-value="tourNumber">
          <input type='hidden' value="#{game.homeTeamName}" data-value="homeTeamName">
          <input type='hidden' value="#{game.homeTeamId}" data-value="homeTeamId">
          <input type='hidden' value="#{game.awayTeamName}" data-value="awayTeamName">
          <input type='hidden' value="#{game.awayTeamId}" data-value="awayTeamId">
          <input type='hidden' value="#{game.placeId}" data-value="placeId">
          <input type='hidden' value="#{game.placeName}" data-value="placeName">
          <input type='hidden' value="#{game.refereeName}" data-value="refereeName">
          <input type='hidden' value="#{game.refereeId}" data-value="refereeId">
          <input type='hidden' value="#{game.homeTeamScore}" data-value="homeTeamScore">
          <input type='hidden' value="#{game.awayTeamScore}" data-value="awayTeamScore">
          <input type='hidden' value="#{game.date}" data-value="date">
          <input type='hidden' value="#{game.time}" data-value="time">
          <td>

            <span style="font-size:14pt">#{game.homeTeamName} - #{game.awayTeamName}</span>
#{ if game.homeTeamScore? then "<span style='font-size:14pt'>#{game.homeTeamScore} - #{game.awayTeamScore}</span>" else ''}
            <span style="float: right" >#{game.tourNumber}тур,#{game.date}</span>

          </td>
        </tr>
              """

    popup: (game, teams, places, referees) =>
      return """
 <div class="modal" >
          <div class="modal-dialog" style='width:800px'>
            <div class="modal-content">
                <input type='hidden' data-value='leagueId' value='#{game.leagueId}'>
                <input type='hidden' data-value='_id' value='#{game._id}'>
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h4 class="modal-title">
                        #{if game._id? then 'Редактирование матча' else 'Добавление матча'}
                    </h4>
                </div>
                <div class="modal-body">
                  <div class="row">
                   <div class="col-xs-2 col-md-2 col-lg-2">
                        <div class="input-group">
                        <span class="input-group-addon">тур</span>
                        <input type="text" class='form-control' data-value='tourNumber' value="#{if game.tourNumber then game.tourNumber else ''}">
                      </div>
                    </div>
                   <div class="col-xs-5 col-md-5 col-lg-5">
                        <input type="hidden" data-target='homeTeamId' data-value='homeTeamName'>
                        <select class="form-control" id="homeTeamId" data-value="homeTeamId">
                          #{("<option value='#{team._id}' #{if team._id is game.homeTeamId then 'selected' else ''}>#{team.name}</option>" for team in teams).join('')}
                        </select>
                    </div>
                    <div class="col-xs-5 col-md-5 col-lg-5" >
                        <input type="hidden" data-target='awayTeamId' data-value='awayTeamName'>
                        <select class="form-control" id="awayTeamId" data-value="awayTeamId">
                          #{("<option value='#{team._id}' #{if team._id is game.awayTeamId then 'selected' else ''}>#{team.name}</option>" for team in teams).join('')}
                        </select>
                    </div>
                  </div><br>
                  <div class="row">
                    <div class="col-xs-3 col-md-3 col-lg-3">
                      <div class="input-group">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                        <input type="text" data-value='date' class='form-control' value='#{if game.date? then game.date else ''}'>
                      </div>
                    </div>
                    <div class="col-xs-2 col-md-2 col-lg-2">
                      <div class="input-group">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-time"></span></span>
                        <input type="text" data-value='time' class='form-control' value='#{if game.time? and game.time isnt 'null' then game.time else ''}'>
                      </div>
                    </div>
                    <div class="col-xs-3 col-md-3 col-lg-3" >
                      <div class="input-group">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-screenshot"></span></span>
                        <input type="hidden" data-target='placeId' data-value='placeName'>
                        <select class="form-control" data-value="placeId" id="placeId">
                            #{("<option value='#{place._id}' #{if place._id is game.placeId then 'selected' else ''}>#{place.name}</option>" for place in places).join('')}
                        </select>
                      </div>
                    </div>
                    <div class="col-xs-4 col-md-4 col-lg-4" >
                      <div class="input-group">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-user"></span></span>
                        <input type="hidden" data-target='refereeId' data-value='refereeName'>
                        <select class="form-control" id="refereeId" data-value="refereeId">
                            <option></option>
                            #{("<option value='#{ref._id}' #{if ref._id is game.refereeId then 'selected' else ''}>#{ref.name}</option>" for ref in referees).join('')}
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
                            <input type="text" class="form-control" data-value="homeTeamScore" value="#{if (game.homeTeamScore? and game.homeTeamScore isnt 'null') then game.homeTeamScore else ''}">
                          </div>
                          <div class="col-xs-2 col-md-2 col-lg-2" >
                            <input type="text" class="form-control" data-value="awayTeamScore"  value="#{if (game.awayTeamScore? and game.awayTeamScore isnt 'null') then game.awayTeamScore else ''}">
                          </div>
                          <div class="col-xs-4 col-md-4 col-lg-4" ></div>
                        </div>
                  </div>
                </div>


                <div class="panel panel-default" id='protocolPanel' style="cursor: pointer">
                  <div class="panel-body">
                        <div class="row">
                          <div class="col-xs-12 col-md-12 col-lg-12" style="text-align: center">
                              <h4>Протокол</h4>
                              <div id='protocol'>
                              </div>
                          </div>
                        </div>
                  </div>
                </div>

                </div>
                <div class="modal-footer">
#{if !game._id? then '' else '<a class="btn btn-danger" id="delGame" style="float:left">Удалить</a>' }
                  <a id="addGame" class="btn btn-success">Сохранить</a>
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
        loadGamesHtml(@value).then((html) ->
          $('#list').html(html)
        )
    ).change()

    $('#addBtn').on('click',  ->
      $(templates.popup(
          exportData($(@).parent().parent()),
          (team for team in teams[0] when team.leagueId is $('#leaguesSelect').val())
          places[0]
          referees[0])
      ).modal(show: true)

      $('.modal select').each(-> $(@).change() )
      $("[data-value='date']").datetimepicker(format: 'DD/MM/YY')
    )

    $('#list').on('click', 'tr', ->
      $(templates.popup(
        exportData($(@))
        (team for team in teams[0] when team.leagueId is $('#leaguesSelect').val())
        places[0]
        referees[0]
      )).modal(show:true)

      $('.modal select').each(-> $(@).change() )

      $("[data-value='date']").datetimepicker(format: 'DD/MM/YY')

    )

    $('body').on('click', '#protocolPanel',  ->
      if !$(@).attr('data-enabled')?
        $(@).attr('data-enabled', true).css(cursor: 'default')

        model = exportData($(@).parent().parent().parent().parent().parent().parent())

        $.getJSON("/players?teamId=#{model.homeTeamId}", (homePlayers) ->
          $.getJSON("/players?teamId=#{model.awayTeamId}", (awayPlayers) ->

            if model._id isnt 'undefined'
              $.getJSON("/games/#{model._id}", (game) ->
                $('#protocol').html(
                  templates.protocol(homePlayers, awayPlayers, game)
                )
              )
            else
              $('#protocol').html(
                templates.protocol(homePlayers, awayPlayers)
              )
          )
        )


    )

    $('body').on('click', '#protocol tr', (e) ->
      #если флажок стоит, то снятие флажка обрабатываем только при нажатии на сам флажок
      if $(@).find('#played').is(':visible')
        if $(e.target).is('#played')
          $(@).find('[data-atom=played]').val(false)
          $(@).removeClass('active').find('#played').fadeOut(150)
          $(@).find('#star').fadeOut(150)
          $(@).find('input:text').fadeOut(150)
        if $(e.target).is('#star')
          if $(@).parent().parent().find('[data-atomt=star]').val()  is true
            $(@).parent().parent().find('[data-atom=star]').val(false)
            $(e.target).css(color: '#f5f5f5')
          else
            $(@).find('[data-atom=star]').val(true)
            $(e.target).css(color: 'black')
      else
        $(@).find('[data-atom=played]').val(true)
        $(@).addClass('active').find('#played').fadeIn(150)
        $(@).find('#star').css(color: '#f5f5f5').fadeIn(150)
        $(@).find('input:text').fadeIn(150)
    )

    $('body').on('click', '#addGame', ->
      model = exportData($(@).parent().parent().parent().parent())
      if model.homeTeamPlayers?
        model.homeTeamPlayers = (pl for pl in model.homeTeamPlayers when pl.played is "true")
        model.awayTeamPlayers = (pl for pl in model.awayTeamPlayers when pl.played is "true")
        for pl in model.homeTeamPlayers
          pl.goals   = pl.goalsassists.split('/')[0]
          pl.assists = pl.goalsassists.split('/')[1]
          pl.yellow  = pl.yellowred.split('/')[0]
          pl.red     = pl.yellowred.split('/')[1]
          delete pl.goalsassists
          delete pl.yellowred

        for pl in model.awayTeamPlayers
          pl.goals   = pl.goalsassists.split('/')[0]
          pl.assists = pl.goalsassists.split('/')[1]
          pl.yellow  = pl.yellowred.split('/')[0]
          pl.red     = pl.yellowred.split('/')[1]
          delete pl.goalsassists
          delete pl.yellowred

      delete model._id if model._id is 'undefined'
      $.post("/games/add", model, -> location.reload())
    )

    $('body').on('click', '#delGame', ->
      model = exportData($(@).parent().parent().parent().parent())
      $.post( '/games/del',{_id: model._id}, -> location.reload())
    )
  )

