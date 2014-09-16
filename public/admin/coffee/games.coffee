$ ->
  templates.games = (games) ->
  console.log games
  """
      <button class="btn btn-block btn-success" id="addBtn" autofocus><span class="glyphicon glyphicon-plus"></span></button>
      <table class="table table-hover">
      #{("<tr>#{templates.hiddenModel(gm)}<td>#{gm.homeTeamName}</td><td>#{gm.awayTeamName}</td><td>#{pl.position}</td></tr>" for gm in games).join('')}
      </table>
  """

  templates.modal = (game) -> """
<div class="modal active" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title">#{if !game? then 'Добавление матча' else 'Редактирование матча'}</h4>
      </div>
      <div class="modal-body">#{templates.modalBody(game)}</div>
      <div class="modal-footer">
        <div class="row">
          <div class="col-xs-6  col-md-6 col-lg-6">
                #{if game? then "<button id='#{player._id}' class='btn btn-danger delBtn' style='float: left'>delete</button>" else ''}
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
  templates.modalBody = (game, teams) -> """
    <div class="row">
          <div class="col-xs-6  col-md-6 col-lg-6">
              #{templates.modal}
          </div>
          <div class="col-xs-6 col-md-6 col-lg-6">
            #{templates.teamSelect(teamSelect(teams))}
          </div>
    </div><br>

    <div class="row">
          <div class="col-xs-2  col-md-2 col-lg-2">
                <input type="text" class="form-control" placeholder='тур'>
          </div>
          <div class="col-xs-6 col-md-6 col-lg-6">
                <input type="text" class="form-control" placeholder='дата'>
          </div>
          <div class="col-xs-4 col-md-4 col-lg-4">
                <input type="text" class="form-control" placeholder='время'>
          </div>
    </div><br>

    <div class="row">
          <div class="col-xs-6  col-md-6 col-lg-6">
            <select></select>
          </div>
          <div class="col-xs-6 col-md-6 col-lg-6">
            <select></select>
          </div>
    </div>
"""

  templates.teamSelect = (teams) ->
    html = "<select class='form-control'>"
    html += ("<option value='#{tm._id}'>#{tm.name}</option>" for tm in teams)
    html += "</select>"

  #==============================================================++#

  $('#container').on('click', '#addBtn',  ->
    $(templates.modal()).modal(show: true)
    $('.modal [data-value=name]').focus()
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
    ).then( (teams, places, referees, games) ->
      $('#container').html(
        templates.games(games[0])
      )
    );