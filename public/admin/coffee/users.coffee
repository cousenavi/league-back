$ ->
  $.getJSON '/leagues', (lg) ->
    window.leagues = lg

    templates.users = (users) -> """
      <button class="btn btn-block btn-success" id="addBtn"><span class="glyphicon glyphicon-plus"></span></button>
      <table class="table table-hover">
      #{("<tr>#{templates.hiddenModel(us)}<td>#{us.login}</td><td>#{us.role}</td></tr>" for us in users).join('')}
      </table>
  """

    templates.popupHeader = (user) ->
      (if user? then 'Редактирование' else 'Добавление')+' юзера'

    templates.popupContent = (user) -> """
      #{if user? then "<input type='hidden' data-value='_id' value='#{user._id}'>" else ""}
      <input type="text" class="form-control" data-value='login' placeholder='login' #{if user? then "value='#{user.login}'" else ""}><br>
      <input type="text" class="form-control" data-value='password' placeholder='password' #{if user? then "value='#{user.password}'" else ""}><br>
      <select data-value="role" id="role" class="form-control">
        <option #{if user? and user.role is 'root' then "selected" else ""}>root</option>
        <option #{if user? and user.role is 'Head' then "selected" else ""}>Head</option>
        <option #{if user? and user.role is 'Captain' then "selected" else ""}>Captain</option>
      </select><br>

      <select data-value="leagueId" id="league" class="form-control">
          <option></option>
        #{("<option value='#{lg._id}' #{if user? and user.leagueId is lg._id then "selected" else ""}>#{lg.name}</option>" for lg in window.leagues)}
      </select><br>
      <span id="team"></span>
  """

    templates.teamSelect= (teams, user) ->
      html = "<select class='form-control' data-value='teamId'>"
      html += ("<option value='#{team._id}' #{if user? and user.teamId is team._id then "selected" else ""}>#{team.name}</option>" for team in teams).join('')
      html += "</select>"


    templates.popupFooter = (user) -> """
  <div class="row">
    <div class="col-xs-6  col-md-6 col-lg-6">
          #{if user? then "<button id='#{user._id}' class='btn btn-danger delBtn' style='float: left'>delete</button>" else ''}
    </div>
    <div class="col-xs-6 col-md-6 col-lg-6">
          <button class="btn btn-success addBtn" tabindex=4>save</button>
    </div>
  </div>
  """

    loadTeams = (leagueId) ->
      @cache = {} if !@cache?
      return new Promise((resolve, reject) =>
        if @cache[leagueId]
          resolve(@cache[leagueId])
        else
          $.getJSON("/teams?leagueId=#{leagueId}", (teams) =>
            @cache[leagueId] = teams
            resolve(@cache[leagueId])
          )
      )

  #-----------------------------------------------------------------#


    request(
      url: '/adminapi/users',
      success: (users) -> $('#container').html templates.users(users)
      error: (err) -> location.href = '/admin'
    )


    #=======================================================#
    $('#container').on('click', '#addBtn',  ->
      head = templates.popupHeader()
      body = templates.popupContent()
      footer = templates.popupFooter()
      $(templates.popup(head, body, footer)).modal(show: true)
    )

    $('body').on('change', '#role', ->
      if @value is 'Head'
        $('#team select').remove()
    )

    $('body').on('change', '#league', ->
      if  $('#role').val() is 'Captain'
        #TODO с мобилы почему-то не работает!!!
        $('#team').html templates.teamSelect([{name: 'test', _id: '1'}])
        teams = loadTeams(@value).then( (teams) ->
          $('#team').html templates.teamSelect(teams)
        )
    )

    $('body').on('click', '.addBtn', ->
      model = extractData($('.modal'))
      request(
        method: 'POST'
        url: '/adminapi/add_user'
        params: model
        success: (data) -> location.reload()
      )
    )
    $('body').on('click', '.delBtn', ->
      id = $(@).attr('id')
      request(
        method: 'POST'
        url: '/adminapi/del_user'
        params: {_id: id}
        success: (data) -> location.reload()
      )
    )

    $('body').on('click', 'table tr', ->
      user = extractData $(@)
      head = templates.popupHeader(user)
      body = templates.popupContent(user)
      footer = templates.popupFooter(user)
      $(templates.popup(head, body, footer)).modal(show: true)
      $('#league').change() #todo костыль. Надо сделать, чтобы teamSelect сразу показывался
    )
    #=============================================================#

