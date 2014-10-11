$ ->
  $.getJSON '/leagues', (lg) ->
    window.leagues = lg

    templates.users = (users) -> """
      <button class="btn btn-block btn-success" id="addBtn"><span class="glyphicon glyphicon-plus"></span></button>
      <table class="table table-hover">
      #{("<tr>#{templates.hiddenModel(us)}<td>#{us.login}</td><td>#{us.role}</td></tr>" for us in users).join('')}
      </table>
  """

    templates.modalBody = (user) ->    """
      <input type='text' class="form-control" data-value='login' placeholder="login" tabindex=1><br>
      <input type='text' class="form-control" data-value='password' placeholder="password" tabindex=2><br>
      <select data-value="leagueId" id="league" class="form-control" tabindex=2>
          <option></option>
        #{("<option value='#{lg._id}' #{if user? and user.leagueId is lg._id then "selected" else ""}>#{lg.name}</option>" for lg in window.leagues)}
      </select>
"""

    templates.modal = (user) -> """
    <div class="modal active" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            #{templates.hiddenModel(user)}
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
            <h4 class="modal-title">#{if !user._id? then 'Добавление главы лиги' else 'Редактирование главы лиги'}</h4>
          </div>
          <div class="modal-body">#{templates.modalBody() }</div>
          <div class="modal-footer">
            <div class="row">
              <div class="col-xs-6  col-md-6 col-lg-6">
                    #{if user._id? then "<button id='#{user._id}' class='btn btn-danger delBtn' style='float: left'>delete</button>" else ''}
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
    #=======================================================#

    user = localStorageRead('user')
    if !user? or user.role isnt 'root' then location.href = '/admin'
    request(
      url: "/adminapi/heads",
      success: (users) -> $('#container').html templates.users(users)
      error: (err) ->  sessionExpired()
    )

    #=======================================================#
    $('#container').on('click', '#addBtn',  ->
      $modal = $(templates.modal({role: 'Head'}))
      $modal.modal(show: true)
      $modal.find('[data-value=name]').focus()
    )

    $('body').on('click', '.addBtn', ->
      console.log model = extractData($('.modal'))
      $('.modal').hide()
      request(
        method: 'POST'
        url: '/adminapi/add_user'
        params: model
        success: () -> location.reload()
        error: ->  sessionExpired()
      )
    )
    $('body').on('click', '.delBtn', ->
      if confirm 'Удалить главу лиги?'
        console.log id = $(@).attr('id')
        request(
          method: 'POST'
          url: '/adminapi/del_user'
          params: {_id: id}
          success: () -> location.reload()
          error: -> sessionExpired()
        )
    )

    $('body').on('click', 'table tr', ->
      user = extractData $(@)
      $modal = $(templates.modal(user))
      fillData($modal, user)
      $modal.modal(show: true)
      $modal.find('[data-value=name]').focus()
    )
#=============================================================#

