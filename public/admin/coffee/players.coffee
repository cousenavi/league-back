$ ->
    templates.users = (players) -> """
      <button class="btn btn-block btn-success" id="addBtn" autofocus><span class="glyphicon glyphicon-plus"></span></button>
      <table class="table table-hover">
      #{("<tr>#{templates.hiddenModel(pl)}<td>#{pl.name}</td><td>#{pl.number}</td><td>#{pl.position}</td></tr>" for pl in players).join('')}
      </table>
  """

    templates.popupHeader = (player) ->
      (if player? then 'Редактирование' else 'Добавление')+' игрока'

    templates.popupContent = (player) ->
      player = player || {teamId: localStorageRead('user').teamId}
      return  """
      #{if player._id? then "<input type='hidden' data-value='_id' value='#{player._id}'>" else ""}
      <input type='hidden' data-value='teamId' value='#{player.teamId}'>
      <div class="row">
         <div class="col-xs-12 col-md-12 col-lg-12">
            <input type="text" class="form-control" data-value='name' value="#{if player.name? then player.name else ''}" tabindex=1 style="text-transform:uppercase;"  tabindex=1 placeholder='NAME'>
         </div>
      </div><br>
      <div class="row">
         <div class="col-xs-6 col-md-6 col-lg-6" >
            <select class="form-control" id="positions" data-value="position" tabindex="2">
                 #{
"<option #{if pos is player.position then 'selected' else ''}>#{pos}</option> " for pos in ['GK', 'CB', 'RB', 'LB', 'CM', 'LM', 'RM', 'ST']
                 }
            </select>
         </div>
         <div class="col-xs-6 col-md-6 col-lg-6" >
            <input type="text" class="form-control" data-value='number'  style='text-align: center' tabindex='3' value="#{if player.number? then player.number else ''}" placeholder='№'>
         </div>
      </div>
  """
    templates.popupFooter = (player) -> """
      <div class="row">
        <div class="col-xs-6  col-md-6 col-lg-6">
              #{if player? then "<button id='#{player._id}' class='btn btn-danger delBtn' style='float: left'>delete</button>" else ''}
        </div>
        <div class="col-xs-6 col-md-6 col-lg-6">
              <button class="btn btn-success addBtn" tabindex=4>save</button>
        </div>
      </div>
  """

    #-----------------------------------------------------------------#

    user = localStorageRead('user')
    if !user? then location.href = '/admin'
    if user.role is 'root'
      'show league selector'
    if user.role is 'Head'
      'show team selector'
    if user.role is 'Captain'
      request(
        url: "/players?teamId=#{user.teamId}",
        success: (players) -> $('#container').html templates.users(players)
        error: (err) ->  sessionExpired()
      )


    #=======================================================#
    $('#container').on('click', '#addBtn',  ->
      head = templates.popupHeader()
      body = templates.popupContent()
      footer = templates.popupFooter()
      $(templates.popup(head, body, footer)).modal(show: true)
      $('.modal [data-value=name]').focus()
    )

    $('body').on('click', '.addBtn', ->
      console.log model = extractData($('.modal'))
      $('.modal').hide()
      request(
        method: 'POST'
        url: '/players/add'
        params: model
        success: (data) -> location.reload()
      )
    )
    $('body').on('click', '.delBtn', ->
      console.log id = $(@).attr('id')
      $('.modal').hide()
      request(
        method: 'POST'
        url: '/players/del'
        params: {_id: id}
        success: (data) -> location.reload()
      )
    )

    $('body').on('click', 'table tr', ->
      player = extractData $(@)
      head = templates.popupHeader(player)
      body = templates.popupContent(player)
      footer = templates.popupFooter(player)
      $(templates.popup(head, body, footer)).modal(show: true)
    )
#=============================================================#

