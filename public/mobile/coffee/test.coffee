$ ->
  templates =
    login: -> """
<div id="loginForm">
<input type="text" data-value="login" placeholder='login' autofocus='true'><br><br>
<input type="password" data-value="password" placeholder='password'><br><br>
<button id="loginBtn">Go!</button>
</div>
"""
    matches: (matches) ->
      ("<button id='#{m._id}'class='match'>#{m.homeTeamName} - #{m.awayTeamName}<br><span class='littleText'>#{m.date} #{m.time} #{m.placeName}</span></button><br>" for m in matches).join('')

    game: (game) ->
      """
<div id="homeTeam">
  <b>#{game.homeTeam.name}</b>
  #{( "<button id='#{id}' class='player homePlayer'>#{p[0]} #{p[1]}</button>" for id, p of game.homeTeam.players).join('')}
  <button id="saveHomeTeamBtn">OK</button>
</div>

<div id="awayTeam" style='display: none'>
  #{("<button id='#{id}' class='player awayPlayer'>#{p[0]} #{p[1]}</button>" for id, p of game.awayTeam.players).join('')}
  <button id="saveAwayTeamBtn">OK</button>
</div>
"""

    events: () ->
      """
  <button class="event" id="goalEvent">Гол</button><br>
  <button class="event" id="yellowEvent">Жк</button><br>
  <button class="event" id="redEvent">Кк</button><br>
  <button class="event" id="endEvent">Конец матча</button><br>
"""

    goalEvent: ->
      ""
    yellowEvent: ->
      ""
    redEvent: ->
      ""

    playerEvent: (eventName) ->
      """
      <table class="playerEventTable" id="#{eventName}"><thead><th>#{registry.currentGame.homeTeam.name}</th><th>#{registry.currentGame.awayTeam.name}</th></thead><tr><td>
      #{if eventName is 'event-goal' then "<input type='button' value='автогол' class='playerEvent'/>"}
      #{("<input type='button' id='#{id}' class='playerEvent' value='#{p[0]}'>" for id, p of registry.currentGame.homeTeam.players).join('')}
      </td><td>
      #{if eventName is 'event-goal' then "<input type='button' value='автогол' class='playerEvent'/>"}
      #{("<input type='button' id='#{id}' class='playerEvent' value='#{p[0]}'>" for id, p of registry.currentGame.awayTeam.players).join('')}
      </td>
      </tr></table>
      <button id="saveEventBtn">OK</button>
"""

    endEvent: ->
        """
      <button id="homeTeamChoise">выбор #{registry.currentGame.homeTeam.name}</button> <br>
      <button type="button" id="awayTeamChoise">выбор #{registry.currentGame.awayTeam.name}</button> <br>
      <button id="saveChoises" #{if !registry.choisesMade then "enabled=false"}>OK</button>
"""

    choise: (side) ->
      players = []
      if side is 'home' then players = registry.currentGame.awayTeam.players else players = registry.currentGame.homeTeam.players
      """
      <div class="strip">оценка судье:</div>
      #{("<input type='button' class='playerEvent refereeMark' value='#{mark}'>" for mark in [2..5]).join('') }
    <br><br><div class="strip">лучшие игроки соперника:</div>
      #{("<input type='button' id='#{id}' class='playerEvent' value='#{p[0]}'>" for id, p of players).join('')}
      <br><br><button id="saveTeamChoise" #{if !registry.choisesMade then "disabled"}>OK</button>
"""
    error: ->
      'error'
  #===================================================#
  #============== common functions ================== #
  extractData = ($el) ->
    data = {}
    $el.find('[data-value]').each( ->
      data[$(@).attr('data-value')] = $(@).val()
    )
    $el.find('[data-collection]').each(->
      key = $(@).attr('data-collection')
      data[key] = []
      $(@).find('[data-element]').each( ->
        obj = {}
        $(@).find('[data-atom]').each( ->
          obj[$(@).attr('data-atom')]  = $(@).val()
        )
        data[key].push(obj)
      )
    )
    return data

  #===================================

  #=========== registry ====================#
  registry = {}

  registry.load = ->
    for key, prop of JSON.parse(localStorage.getItem('registry'))
      registry[key] = prop

  registry.save = ->
    localStorage.setItem('registry', JSON.stringify(registry))

  registry.sync = ->
    console.log 'здесь мы синхронизируем регистр с сервером'

  registry.endGame = () ->
    @currentGame.ended = true
    @sync()
    @save()

  registry.setCurrentGame = (game) ->
    @currentGame = game
    @save()

  registry.setUser = (user) ->
    @currentUser = user
    @save()

  registry.setPlayerActivity = (id, isActive) ->
    if @currentGame.homeTeam.players[id]?
      @currentGame.homeTeam.players[id][2] = isActive
    else
      @currentGame.awayTeam.players[id][2] = isActive
    @save()
  #=========================================#



  registry.load()
  if !registry.currentUser?
    $('#container').html(templates.login())
  else if !registry.currentGame?
    $.ajax(
      url: '/matches'
      method: 'GET'
      success: (matches) ->
        $('#container').html(templates.matches(matches))
      error:   -> $('#container').html(templates.error)
    )
  else if !registry.currentGame.ended?
    $('#container').html(templates.events())
  else
    $('#container').html(templates.endEvent())



  #============== events ================== #
  $('#container').on('click', '#loginBtn', ->
    $(@).html('...').attr('disabled', 'true')
    data = extractData $(@).parent()
    $.ajax(
      url: '/login'
      method: 'POST'
      data: data
      success: (matches) ->
        registry.setUser(true)
        $('#container').html(templates.matches(matches))
      error:   -> $(@).html('Go!')
    )
  )

  $('#container').on('click', '.match', ->
    $(@).parent().find('.match').each( -> $(@).attr('disabled', true))
    $(@).html('...')
    $.ajax(
      url: "/game?_id=#{$(@).attr('id')}"
      success: (game) ->
        registry.setCurrentGame(game)
        $('#container').html(templates.game(game))
      error: -> $('#container').html(templates.error())
    )
  )

  $('#container').on('click', '.player', ->
    $(@).toggleClass('activePlayer')
    registry.setPlayerActivity($(@).attr('id'), $(@).hasClass('activePlayer'))
  )

  $('#container').on('click', '#saveHomeTeamBtn', ->
    $('#homeTeam').hide()
    $('#awayTeam').show()
  )

  $('#container').on('click', '#saveAwayTeamBtn', ->
    registry.sync()
    $('#container').html(templates.events())
  )

  $('#container').on('click', '#goalEvent', ->
    $('#container').html(templates.goalEvent())
  )

  $('#container').on('click', '#yellowEvent', ->
    $('#container').html(templates.yellowEvent())
  )

  $('#container').on('click', '#redEvent', ->
    $('#container').html(templates.redEvent())
  )

  $('#container').on('click', '#endEvent', ->
    if (confirm 'Закончить матч? Это действие нельзя будет отменить')
       registry.endGame()
       $('#container').html(templates.endEvent());
  )

  $('#container').on('click', '#homeTeamChoise', ->
    $('#container').html(templates.choise('home'))
  )
  $('#container').on('click', '#awayTeamChoise', ->
    $('#container').html(templates.choise('away'))
  )

  $('#container').on('click', '#event-goal input',  ->
    if $('.playerEventTable .goal').length is 0
      $(@).addClass('goal')
    else if $(@).hasClass('goal')
      $(@).removeClass('goal')
    else if $(@).hasClass('assist')
      $(@).removeClass('assist')
    else
      $(@).addClass('assist')
  )

  $('#container').on('click', '#saveEvent', ->
    console.log 'ok'
  )
  #=========================================#



