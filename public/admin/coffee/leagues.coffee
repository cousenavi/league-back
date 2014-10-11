$ ->
    templates.leagues = (leagues) -> """
      <button class="btn btn-block btn-success" id="addBtn" autofocus><span class="glyphicon glyphicon-plus"></span></button>
      <table class="table table-hover">
      #{("<tr>#{templates.hiddenModel(lg)}<td>#{lg.name}</td><td>#{lg.logo}</td></tr>" for lg in leagues).join('')}
      </table>
  """

    templates.modalBody = ->    """
      <input type='text' class="form-control" data-value='name' placeholder="name" tabindex=1><br>
      <input type='text' class="form-control" data-value='logo' placeholder="logo" tabindex=2>
"""

    templates.modal = (league) -> """
    <div class="modal active" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            #{templates.hiddenModel(league)}
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
            <h4 class="modal-title">#{if !league._id? then 'Добавление лиги' else 'Редактирование лиги'}</h4>
          </div>
          <div class="modal-body">#{templates.modalBody() }</div>
          <div class="modal-footer">
            <div class="row">
              <div class="col-xs-6  col-md-6 col-lg-6">
                    #{if league._id? then "<button id='#{league._id}' class='btn btn-danger delBtn' style='float: left'>delete</button>" else ''}
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
    #-----------------------------------------------------------------#

    user = localStorageRead('user')
    if !user? or user.role isnt 'root' then location.href = '/admin'
    request(
      url: "/leagues",
      success: (leagues) -> $('#container').html templates.leagues(leagues)
      error: (err) ->  sessionExpired()
    )


    #=======================================================#
    $('#container').on('click', '#addBtn',  ->
      $modal = $(templates.modal({}))
      $modal.modal(show: true)
      $modal.find('[data-value=name]').focus()
    )

    $('body').on('click', '.addBtn', ->
      console.log model = extractData($('.modal'))
      $('.modal').hide()
      request(
        method: 'POST'
        url: '/leagues/add'
        params: model
        success: () -> location.reload()
        error: ->  sessionExpired()
      )
    )
    $('body').on('click', '.delBtn', ->
      if confirm 'Удалить лигу?'
        console.log id = $(@).attr('id')
        request(
          method: 'POST'
          url: '/leagues/del'
          params: {_id: id}
          success: () -> location.reload()
          error: -> sessionExpired()
        )
    )

    $('body').on('click', 'table tr', ->
      league = extractData $(@)
      $modal = $(templates.modal(league))
      fillData($modal, league)
      $modal.modal(show: true)
      $modal.find('[data-value=name]').focus()
    )
    #=============================================================#

