$ ->
  templates.sections =  (user) ->
    if user.role is 'root'
      html = """
         <a class='btn btn-block btn-info btn-list' href="leagues" tabindex='1'>Leagues</a>
         <a class='btn btn-block btn-info btn-list' href="heads" tabindex='2'>Heads</a>
"""
    if user.role is 'Head'
      html = """
        <a class='btn btn-block btn-info btn-list' href="games" tabindex='1'>Games</a>
        <a class='btn btn-block btn-info btn-list' href="teams" tabindex='2'>Teams</a>
        <a class='btn btn-block btn-info btn-list' href="referees" tabindex='3'>Referees</a>
"""

    if user.role is 'Capitan'
      html = """
"""

    html += '<a class="btn btn-block btn-success btn-list" id="logoutBtn" tabindex="3">Logout</a>'

    return html

  templates.login = -> """
    <div id="loginForm">
    <input type="text" data-value="login" class="form-control"
    placeholder='login' autocomplete='true' autofocus
    #{ if login = getCookie('login') then "value=\"#{login}\"" else '' }><br>
    <input type="password" data-value="password" class="form-control" placeholder='password' autocomplete='true'><br>
    <button id="loginBtn" class="btn btn-success btn-block">Go!</button>
     </div>
"""

  $('body').on('login', (event, user) ->
    if user.role is 'Captain'
      location.href = 'players'
    else
      $('#container').html(templates.sections(user))
  )

  $('#container').on('click', '#logoutBtn', ->
    sessionExpired()
  )

  $('#container').on('click', '#loginBtn', ->
    $(@).html('...')
    model = extractData($(@).parent())
    request(
      url: '/adminapi/login',
      method: 'POST',
      params: model,
      success: (user) ->
        localStorage.setItem('user', JSON.stringify(user))
        $('body').trigger('login', [user])
      error: (error) ->
        $('#loginBtn').html('Go!')
        $('#container .alert-danger').remove()
        $('#container').prepend(window.templates.error(error.responseText))
    )
  )

  $('#container').on('keyup', '[data-value=login]', ->
    setCookie('login', $(@).val())
  )

  #-------------------------------------#

  if user = localStorageRead('user')
    request(
      url: '/adminapi/info'
      success: -> $('body').trigger('login', [user])
      error: -> $('#container').html(templates.login())
    )
  else
    $('#container').html(templates.login())
