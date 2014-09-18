$ ->
  templates.users = (referees) -> """
      <button class="btn btn-block btn-success" id="addBtn" autofocus><span class="glyphicon glyphicon-plus"></span></button>
      <table class="table table-hover">
      #{("<tr>#{templates.hiddenModel(ref)}<td>#{ref.name}</td></tr>" for ref in referees).join('')}
      </table>
  """

  templates.modal = (referee) -> """
<div class="modal active" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        #{templates.hiddenModel(referee)}
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title">#{if !referee._id? then 'Добавление судьи' else 'Редактирование судьи'}</h4>
      </div>
      <div class="modal-body">#{templates.modalBody(referee) }</div>
      <div class="modal-footer">
        <div class="row">
          <div class="col-xs-6  col-md-6 col-lg-6">
                #{if referee._id? then "<button id='#{referee._id}' class='btn btn-danger delBtn' style='float: left'>delete</button>" else ''}
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

  templates.modalBody = (game, teams) ->    """
    <input type='text' class="form-control" data-value='name' style="text-transform:uppercase;" placeholder="name" tabindex=1><br>
    <input type='text' class="form-control" data-value='login' placeholder="login" tabindex=2><br>
    <input type='text' class="form-control" data-value='password' placeholder="password" tabindex=3>
"""

  #-----------------------------------------------------------------#

  user = localStorageRead('user')
  if !user? then location.href = '/admin'
  if user.role is 'root'  then location.href = '/admin'
  if user.role is 'Captain' then location.href = '/admin'
  if user.role is 'Head'
    request(
      url: "/referees",
      success: (refs) -> $('#container').html templates.users(refs)
      error: (err) ->  sessionExpired()
    )

  #=======================================================#
  $('#container').on('click', '#addBtn',  ->
    ref = {leagueId: user.leagueId}
    $modal = $(templates.modal(ref))
    fillData($modal, ref)
    $modal.modal(show: true)
    $modal.find('[data-value=name]').focus()
  )

  $('body').on('click', '.addBtn', ->
    console.log model = extractData($('.modal'))
    $('.modal').hide()
    request(
      method: 'POST'
      url: '/referees/add'
      params: model
      success: (data) -> location.reload()
      error: ->  sessionExpired()
    )
  )
  $('body').on('click', '.delBtn', ->
    console.log id = $(@).attr('id')
    request(
      method: 'POST'
      url: '/referees/del'
      params: {_id: id}
      success: (data) -> location.reload()
      error: -> sessionExpired()
    )
  )

  $('body').on('click', 'table tr', ->
    ref = extractData $(@)
    $modal = $(templates.modal(ref))
    fillData($modal, ref)
    $modal.modal(show: true)
    $modal.find('[data-value=name]').focus()
  )
#=============================================================#

