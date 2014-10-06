$ ->
  templates.teams = (teams) -> """
      <button class="btn btn-block btn-success" id="addBtn" autofocus><span class="glyphicon glyphicon-plus"></span></button>
      <table class="table table-hover">
      #{("<tr>#{templates.hiddenModel(tm)}<td><img src='/#{tm.logo}' style='height: 25px;'> #{tm.name}</td></tr>" for tm in teams).join('')}
      </table>
  """

  templates.modal = (team) -> """
<div class="modal active" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        #{templates.hiddenModel(team)}
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title">#{if !team._id? then 'Добавление команды' else 'Редактирование команды'}</h4>
      </div>
      <div class="modal-body">#{templates.modalBody(team) }</div>
      <div class="modal-footer">
        <div class="row">
          <div class="col-xs-6  col-md-6 col-lg-6">
                #{if team._id? then "<button id='#{team._id}' class='btn btn-danger delBtn' style='float: left'>delete</button>" else ''}
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

  templates.modalBody = (team) ->    """
    <input type='text' class="form-control" data-value='name' placeholder="name" tabindex=1><br>
    <input type='text' class="form-control" data-value='logo' placeholder="logo" tabindex=2><br>
"""

  #-----------------------------------------------------------------#

  user = localStorageRead('user')
  if !user? then location.href = '/admin'
  if user.role is 'root'  then location.href = '/admin'
  if user.role is 'Captain' then location.href = '/admin'
  if user.role is 'Head'
    request(
      url: "/teams?leagueId=#{user.leagueId}",
      success: (teams) -> $('#container').html templates.teams(teams)
      error: (err) ->  sessionExpired()
    )

  #=======================================================#
  $('#container').on('click', '#addBtn',  ->
    team = {leagueId: user.leagueId}
    $modal = $(templates.modal(team))
    fillData($modal, team)
    $modal.modal(show: true)
    $modal.find('[data-value=name]').focus()
  )

  $('body').on('click', '.addBtn', ->
    console.log model = extractData($('.modal'))
    $('.modal').hide()
    request(
      method: 'POST'
      url: '/teams/add'
      params: model
      success: (data) -> location.reload()
      error: ->  sessionExpired()
    )
  )
  $('body').on('click', '.delBtn', ->
    console.log id = $(@).attr('id')
    request(
      method: 'POST'
      url: '/teams/del'
      params: {_id: id}
      success: (data) -> location.reload()
      error: -> sessionExpired()
    )
  )

  $('body').on('click', 'table tr', ->
    team = extractData $(@)
    $modal = $(templates.modal(team))
    fillData($modal, team)
    $modal.modal(show: true)
    $modal.find('[data-value=name]').focus()
  )
#=============================================================#

