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
      console.log game
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

    error: ->
      'error'
  #====================================

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

  $('#container').html(templates.login())

  #============== events ================== #
  $('#container').on('click', '#loginBtn', ->
    $(@).html('...').attr('disabled', 'true')
    data = extractData $(@).parent()
    $.ajax(
      url: '/login'
      method: 'POST'
      data: data
      success: (matches) -> $('#container').html(templates.matches(matches))
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
  )
  #=========================================#

  #=========== registry ====================#
  registry = {
    currentGame: undefined
  }
  registry.save = ->
    console.log 'здесь мы должны сохранить регистр в локал сторедж'

  registry.sync = ->
    console.log 'здесь мы синхронизируем регстр с сервером'

  registry.setCurrentGame = (game) ->
    @currentGame = game
    @save()

  registry.setPlayerActivity = (id, isActive) ->
    if @currentGame.homeTeam.players[id]?
      @currentGame.homeTeam.players[id][2] = isActive
    else
      @currentGame.awayTeam.players[id][2] = isActive
    @save()
  #=========================================#


