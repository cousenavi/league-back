$ ->
  templates.sections =  (user) ->
    html = ''
    if user.role is 'Head' or user.role is 'root'
      html += """
          <a class='btn btn-block btn-info match' href="teams" disabled>Teams</a><br>
"""

    if user.role is 'Head' or user.role is 'root'
      html += """
          <a class='btn btn-block btn-info match' href="players" disabled>Players</a><br>
"""
    if user.role is 'Head' or user.role is 'root'
      html += """
          <a class='btn btn-block btn-info match' href="games">Games</a><br>
"""
    if user.role is 'Head' or user.role is 'root'
      html += """
          <a class='btn btn-block btn-info match' href="referees">Referrees</a><br>
"""

    if user.role is 'Head' or user.role is 'root'
      html += """
          <a class='btn btn-block btn-info match' href="places" disabled>Places</a><br>
"""

    if user.role is 'root'
      html += """
          <a class='btn btn-block btn-info match' href="users">Users</a><br>
"""
    html

  templates.login = -> """
    <div id="loginForm">
    <input type="text" data-value="login" class="form-control"
    placeholder='login' autocomplete='true'
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
