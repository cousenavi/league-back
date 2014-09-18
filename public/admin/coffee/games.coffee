$ ->
  templates.games = (games) ->
    currDate = ""
    """
      <button class="btn btn-block btn-success" id="addBtn" autofocus><span class="glyphicon glyphicon-plus"></span></button>
      <table class="table">
      #{( (if currDate isnt gm.date then templates.separationRow(currDate = gm.date) else '')+"<tr #{if !gm.homeTeamScore? then 'class=\'game-notstarted\'' else ''}>#{templates.hiddenModel(gm)}<td>#{gm.homeTeamName} - #{gm.awayTeamName}
      #{if gm.homeTeamScore? then '<b>'+gm.homeTeamScore+'- '+gm.awayTeamScore+'</b>' else ''}
      </td><td style='text-align: right'>#{gm.tourNumber}тур</td></tr>
" for gm in games).join('')}
      </table>
  """

  templates.separationRow = (dt) ->
    "<tr><td></td><td></td></tr><tr class='separation-row'><td>#{dt}</td></tr>"


  templates.modal = (game, teams, referees) -> """
<div class="modal active" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        #{templates.hiddenModel(game)}
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title">#{if !game._id? then 'Добавление матча' else 'Редактирование матча'}</h4>
      </div>
      <div class="modal-body">#{templates.modalBody(game, teams, referees) }</div>
      <div class="modal-footer">
        <div class="row">
          <div class="col-xs-6  col-md-6 col-lg-6">
                #{if game._id? then "<button id='#{game._id}' class='btn btn-danger delBtn' style='float: left'>delete</button>" else ''}
          </div>
          <div class="col-xs-6 col-md-6 col-lg-6">
                <button class="btn btn-success addBtn" tabindex=4>save</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
"""

  templates.modalBody = (game, teams, referees) -> """
    <div class="row">
          <div class="col-xs-6 col-md-6 col-lg-6" data-select-id="homeTeamId" data-select-value="homeTeamName">
            #{templates.teamSelect(teams)}
          </div>
          <div class="col-xs-6 col-md-6 col-lg-6" data-select-id="awayTeamId" data-select-value="awayTeamName">
            #{templates.teamSelect(teams)}
          </div>
    </div><br>

    <div class="row">
          <div class="col-xs-5  col-md-5 col-lg-5">
                <input type="text" data-value="tourNumber" class="form-control" placeholder='тур'>
          </div>
          <div class="col-xs-7 col-md-7 col-lg-7">
                <input type="text" id="date" data-value="date" class="form-control" placeholder='дата'>
          </div>
    </div><br>
    <div class="row">
          <div class="col-xs-6  col-md-6 col-lg-6" data-select-id="refereeId" data-select-value="refereeName">
            #{templates.refSelect(referees)}
          </div>
<!--
          <div class="col-xs-6 col-md-6 col-lg-6">
            <select></select>
          </div>
-->
    </div>
"""

  templates.teamSelect = (teams) ->
    html = "<select class='form-control'>"
    html += ("<option value='#{tm._id}'>#{tm.name}</option>" for tm in teams)
    html += "</select>"

  templates.refSelect = (referees) ->
    html = "<select class='form-control'>"
    html += "<option></option>"
    html += ("<option value='#{ref._id}'>#{ref.name}</option>" for ref in referees)
    html += "</select>"

  #==============================================================++#

  $('body').on('click', '.addBtn', ->
    console.log model = extractData($('.modal'))
    $('.modal').hide()
    request(
      method: 'POST'
      url: '/games/add'
      params: model
      success: (data) -> location.reload()
    )
  )

  $('body').on('click', '.delBtn', ->
    console.log id = $(@).attr('id')
    $('.modal').hide()
    request(
      method: 'POST'
      url: '/games/del'
      params: {_id: id}
      success: (data) -> location.reload()
    )
  )

  #==============================================================++#

  user = localStorageRead('user')
  if !user? then location.href = '/admin'
  if user.role is 'root' then location.href = '/admin'
  if user.role is 'Captain' then location.href = '/admin'
  if user.role is 'Head'

    $.when(
      $.getJSON("/teams?leagueId=#{user.leagueId}")
      $.getJSON('/places')   #todo здесь тоже добавить проверку на принадлежность лиге
      $.getJSON('/referees') #todo здесь тоже добавить проверку на принадлежность лиге
      $.getJSON("/games?leagueId=#{user.leagueId}")
    ).then(
      (teams, places, referees, games) ->
        teams = teams[0]; referees = referees[0]
        $('#container').on('click', '#addBtn',  ->
          game = {leagueId: user.leagueId}
          $modal = $(templates.modal(game, teams, referees))
          $modal.find('#date').datetimepicker({format: 'DD/MM/YY'})
          $modal.modal(show: true)
          $('.modal select:eq(0)').focus()

        )
        $('body').on('click', 'table .game-notstarted', ->
          game = extractData $(@)
          $modal = $(templates.modal(game, teams, referees))
          fillData($modal, game)
          $modal.modal(show: true)
          $("#date").datetimepicker(format: 'DD/MM/YY')
        )

        $('#container').html(
          templates.games(games[0])
        )
      ,
      (error) ->
        sessionExpired()
    )

