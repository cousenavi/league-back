$ ->
  templates =
    login: -> """
<div id="loginForm">
<input type="text" data-value="login" class="form-control" placeholder='login'><br>
<input type="password" data-value="password" class="form-control" placeholder='password'><br>
<button id="loginBtn" class="btn btn-success btn-block">Go!</button>
</div>
"""
    matches: (matches) ->
      html = """
        <nav class="navbar navbar-default" role="navigation">
            <div class="navbar-header">
                <a class="navbar-brand">Выберите матч</a>
            </div>
        </nav>
"""
      html += ("<button class='btn btn-block btn-info match' id='#{m._id}'class='match'>#{m.homeTeamName} <br> #{m.awayTeamName}<br><span class='smallText'>#{m.date} #{m.time} #{m.placeName}</span></button><br>" for m in matches).join('')

    events: () ->
      """
      <nav class="navbar navbar-default" role="navigation">
            <div class="navbar-header">
                <a class="navbar-brand"> #{registry.currentGame.homeTeamName} #{registry.currentGame.homeTeamScore}-#{registry.currentGame.awayTeamScore} #{registry.currentGame.awayTeamName}</a>
            </div>
      </nav>
  <button class="btn btn-block btn-info event" id="lineUpEvent">Составы</button><br>
  <button class="btn btn-block btn-info event" id="goalEvent">Голы</button><br>
  <button class="btn btn-block btn-info event" id="yellowEvent">Жёлтые</button><br>
  <button class="btn btn-block btn-info event" id="redEvent">Прямые красные</button><br>
  <button class="btn btn-block btn-success event" id="endEvent">Конец матча</button><br>
"""
    
    lineUpEvent: () ->      """
<div id="homeTeam" class="protocol">
    <nav class="navbar navbar-default" role="navigation">
            <div class="navbar-header">
                <a class="navbar-brand">#{registry.currentGame.homeTeamName}: состав</a>
            </div>
      </nav>
  #{( "<button class='btn btn-block btn-default player homePlayer' id='#{id}' >#{p.number} #{p.name}</button>" for id, p of registry.currentGame.homeTeamPlayers).join('')}
  <button class='btn btn-block btn-success'  id="saveHomeTeamBtn">OK</button>
</div>

<div id="awayTeam" class="protocol">
      <nav class="navbar navbar-default" role="navigation">
            <div class="navbar-header">
                <a class="navbar-brand">#{registry.currentGame.awayTeamName}: состав</a>
            </div>
      </nav>
  #{("<button class='btn btn-block btn-default player awayPlayer'  id='#{id}'>#{p.number} #{p.name}</button>" for id, p of registry.currentGame.awayTeamPlayers).join('')}
  <button class='btn btn-block btn-success' id="saveAwayTeamBtn">OK</button>
</div>
"""
      
    goalEvent: ->
      """
      <span id='goal'>
        <nav class="navbar navbar-default" role="navigation">
          <div class="navbar-header">
            <a class="navbar-brand">Гол</a>
          </div>
        </nav>
          <div class="btn-group btn-group-justified">
      <a class="btn btn-default active goalEventType" role="button" id="G+">Гол+ </a>
      <a class="btn btn-default goalEventType" role="button" id="A+">Пас+ </a>
      <a class="btn btn-default goalEventType" role="button" id="G-">Гол-</a>
      <a class="btn btn-default goalEventType" role="button" id="A-">Пас-</a>
    </div>
          <h2>#{registry.currentGame.homeTeamName}</h2>
          #{("<button id='#{id}' class='btn btn-default playerEvent'>#{pl.number}
            <span class='goals'>#{if pl.goals? then pl.goals else 0}</span>
            <span class='assists'>#{if pl.assists? then pl.assists else 0}</span>
          </button> " for id, pl of registry.currentGame.homeTeamPlayers).join('')}
          <h2>#{registry.currentGame.awayTeamName}</h2>
          #{("<button id='#{id}' class='btn btn-default playerEvent'>#{pl.number}
              <span class='goals'>#{if pl.goals? then pl.goals else 0}</span>
              <span class='assists'>#{if pl.assists? then pl.assists else 0}</span>
            </button> " for id, pl of registry.currentGame.awayTeamPlayers).join('')}
<br><br>
        <button class="btn btn-block btn-success" id="saveEvent">OK</button>
      </span>
"""

    yellowEvent: ->
      """
      <span id='yellow'>
      <nav class="navbar navbar-default" role="navigation">
        <div class="navbar-header">
          <a class="navbar-brand">Жёлтая карточка</a>
        </div>
      </nav>
        <h4>Millwall</h4>
        #{("<button id='#{id}' class='btn btn-default playerEvent #{if pl.yellow is 2 then "btn-selected-red" else if pl.yellow is 1 then "btn-selected-yellow" else ""}'>#{pl.number}</button> " for id, pl of registry.currentGame.homeTeamPlayers).join('')}
        <h4>Wimbledon</h4>
        #{("<button id='#{id}' class='btn btn-default playerEvent #{if pl.yellow is 2 then "btn-selected-red" else if pl.yellow is 1 then "btn-selected-yellow" else ""}'>#{pl.number}</button> " for id, pl of registry.currentGame.awayTeamPlayers).join('')}

      <br><br><button class="btn btn-block btn-success" id="saveEvent">OK</button>
      </span>
"""

    redEvent: ->
      console.log registry.currentGame.homeTeamPlayers
      """
      <span id='red'>
      <nav class="navbar navbar-default" role="navigation">
        <div class="navbar-header">
          <a class="navbar-brand">Прямая красная</a>
        </div>
      </nav>
        <h4>Millwall</h4>
        #{("<button id='#{id}' class='btn btn-default playerEvent #{if pl.red is 1 then "btn-selected-red" else ""}'>#{pl.number}</button> " for id, pl of registry.currentGame.homeTeamPlayers).join('')}
        <h4>Wimbledon</h4>
        #{("<button id='#{id}' class='btn btn-default playerEvent #{if pl.red is 1 then "btn-selected-red" else ""}' >#{pl.number}</button> " for id, pl of registry.currentGame.awayTeamPlayers).join('')}

      <br><br><button class="btn btn-block btn-success" id="saveEvent">OK</button>
      </span>
"""

    endEvent: ->
        """
      <button class="btn btn-block btn-info" id="homeTeamChoise">выбор<br>#{registry.currentGame.homeTeamName}</button> <br>
      <button class="btn btn-block btn-info"  type="button" id="awayTeamChoise">выбор<br>#{registry.currentGame.awayTeamName}</button> <br>
      <button class="btn btn-block btn-success" id="saveChoises">OK</button>
"""

    choise: (side) ->
      players = []
      if side is 'Home'
        players = registry.currentGame.awayTeamPlayers
        team = registry.currentGame.homeTeam
      else
        players = registry.currentGame.homeTeamPlayers
        team = registry.currentGame.awayTeam

      html = """
        <nav class="navbar navbar-default" role="navigation">
            <div class="navbar-header">
                <a class="navbar-brand">#{team.name}: оценка судье</a>
            </div>
        </nav>
    <div>
        <div class="row">
"""
      for mark in [2..5]
        html += """
        <div class="col-xs-3 col-md-3 col-lg-3">
          <button type="button" class='btn btn-default btn-block refereeMark mark#{side} #{if mark is team.refereeMark then ":active" else ""  }'>#{mark}</button>
        </div>
"""

      html += """
        </div><br>
          <nav class="navbar navbar-default" role="navigation">
            <div class="navbar-header">
                <a class="navbar-brand">лучшие игроки соперника</a>
            </div>
          </nav>
        <div>
        #{("<button class='btn btn-default playerEvent bestPlayer #{if pl.star? then ":active" else ""}'  id='#{id}' class='playerEvent bestPlayer }'>#{pl.number}</button>" for id, pl of players).join('')}
        </div><br><button class="btn btn-block btn-success" id="save#{side}TeamChoise">OK</button>
"""

#===============================================================================================================#
#===============================================================================================================#
#===============================================================================================================#

#===========      registry     ====================#
  registry = {
    currentEvent: 'G+'
  }

  registry.load = ->
    for key, prop of JSON.parse(localStorage.getItem('registry'))
      registry[key] = prop

  registry.save = ->
    localStorage.setItem('registry', JSON.stringify(registry))

  registry.sync = (callback) ->
    console.log 'здесь мы синхронизируем регистр с сервером'
    callback?()

  registry.endGame = () ->
    @currentGame.ended = true
    @sync()
    @save()

  registry.setCurrentGame = (game) ->
    @currentGame = game
    if game then @currentGame.homeTeamScore = @currentGame.awayTeamScore = 0
    @save()

  registry.setUser = (user) ->
    @currentUser = user
    @save()

  registry.setHomeRefereeMark = (mark) ->
    @currentGame.homeTeam.refereeMark = parseInt(mark)
    @save()

  registry.setAwayRefereeMark = (mark) ->
    @currentGame.awayTeam.refereeMark = parseInt(mark)
    @save()

  registry.removeBestPlayer = (id) ->
    if @currentGame.homeTeamPlayers[id]?
      delete @currentGame.homeTeamPlayers[id].star
    else
      delete @currentGame.awayTeamPlayers[id].star
    @save()

  registry.setBestPlayer = (id) ->
    if @currentGame.homeTeamPlayers[id]?
      @currentGame.homeTeamPlayers[id].star = true
    else
      @currentGame.awayTeamPlayers[id].star = true
    @save()

  registry.setPlayerActivity = (id, isActive) ->
    if @currentGame.homeTeamPlayers[id]?
      @currentGame.homeTeamPlayers[id].played = isActive
    else
      @currentGame.awayTeamPlayers[id].played = isActive
    @save()

  #todo эти четыре метода сжать в один сеттер

  registry.setPlayerGoals = (id, goals) ->
    if @currentGame.homeTeamPlayers[id]?
      @currentGame.homeTeamPlayers[id].goals = goals
    else
     @currentGame.awayTeamPlayers[id].goals = goals

    @currentGame.homeTeamScore = @currentGame.awayTeamScore = 0
    @currentGame.homeTeamScore += parseInt(pl.goals) for id, pl of @currentGame.homeTeamPlayers when pl.goals?
    @currentGame.awayTeamScore += parseInt(pl.goals) for id, pl of @currentGame.awayTeamPlayers when pl.goals?

    @save()


  registry.setPlayerAssists = (id, assists) ->
    if @currentGame.homeTeamPlayers[id]?
      @currentGame.homeTeamPlayers[id].assists = assists
    else
     @currentGame.awayTeamPlayers[id].assists = assists
    @save()

  registry.setPlayerYellow = (id, yellow) ->
    if @currentGame.homeTeamPlayers[id]?
      @currentGame.homeTeamPlayers[id].yellow = yellow
    else
      @currentGame.awayTeamPlayers[id].yellow = yellow
    @save()

  registry.setPlayerRed = (id, red) ->
    if @currentGame.homeTeamPlayers[id]?
      @currentGame.homeTeamPlayers[id].red = red
    else
      @currentGame.awayTeamPlayers[id].red = red
    @save()


#=========================================================================================================#
#=========================================================================================================#
#=========================================================================================================#

  #============== events ================== #
  $('#container').on('click', '#loginBtn', ->
    $(@).html('...')
    model = extractData($(@).parent())
    request(
      url: '/login',
      method: 'POST',
      params: model,
      success: (matches) ->
        localStorage.setItem('loggedIn', true )
        $('#container').html(templates.matches(matches))
      error: (error) ->
        $('#loginBtn').html('Go!')
        $('#container .alert-danger').remove()
        $('#container').prepend(window.templates.error(error.responseText))
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
      error: (err) -> refSessionExpired()
    )
  )

  $('#container').on('click', '.protocol .player', ->
    $(@).toggleClass('btn-selected')
    registry.setPlayerActivity($(@).attr('id'), $(@).hasClass('btn-selected'))
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
    $('#container').html(templates.choise('Home'))
  )
  $('#container').on('click', '#awayTeamChoise', ->
    $('#container').html(templates.choise('Away'))
  )
    #-- event -- #
  $('#container').on('click', '.goalEventType', ->
    $(@).parent().find('.goalEventType').each(-> $(@).removeClass('active'))
    $(@).addClass('active')
    registry.currentEvent  =  $(@).attr('id')
  )

  $('#container').on('click', '#goal .playerEvent', ->
    if registry.currentEvent is 'G+' then $(@).find('.goals').html( parseInt($(@).find('.goals').html()) + 1 )
    if registry.currentEvent is 'G-' then $(@).find('.goals').html( parseInt($(@).find('.goals').html()) - 1 )
    if registry.currentEvent is 'A+' then $(@).find('.assists').html( parseInt($(@).find('.assists').html()) + 1 )
    if registry.currentEvent is 'A-' then $(@).find('.assists').html( parseInt($(@).find('.assists').html()) - 1 )
    registry.setPlayerGoals($(@).attr('id'),  $(@).find('.goals').html())
    registry.setPlayerAssists($(@).attr('id'),  $(@).find('.assists').html())
  )

  $('#container').on('click', '#yellow .playerEvent', ->
    if $(@).hasClass('btn-selected-yellow')
      $(@).removeClass('btn-selected-yellow').addClass('btn-selected-red')
      registry.setPlayerYellow($(@).attr('id'), 2)
    else if $(@).hasClass('btn-selected-red')
      $(@).removeClass('btn-selected-red')
      registry.setPlayerYellow($(@).attr('id'), 0)
    else
      $(@).addClass('btn-selected-yellow')
      registry.setPlayerYellow($(@).attr('id'), 1)

  )

  $('#container').on('click', '#red .playerEvent', ->
    if $(@).hasClass('btn-selected-red')
      $(@).removeClass('btn-selected-red')
      registry.setPlayerRed($(@).attr('id'), 0)
    else
      $(@).addClass('btn-selected-red')
      registry.setPlayerRed($(@).attr('id'), 1)
  )

    #----- ------#

    #--- team choises --#
  $('#container').on('click', '.refereeMark', ->
    if $(@).hasClass('markHome') then registry.setHomeRefereeMark($(@).html()) else registry.setAwayRefereeMark($(@).html())

    $(@).parent().parent().find('.btn-selected').each(-> $(@).removeClass('btn-selected'))
    $(@).addClass('btn-selected')
  )

  $('#container').on('click', '.bestPlayer', ->
    if ($(@).hasClass('btn-selected'))
      $(@).removeClass('btn-selected')
      registry.removeBestPlayer($(@).attr('id'))
    else if $(@).parent('.btn-selected').length < 3
      $(@).addClass('btn-selected')
      registry.setBestPlayer($(@).attr('id'))
  )

  $('#container').on('click', '#saveHomeTeamChoise', ->
    $('#container').html(templates.endEvent())
  )
  $('#container').on('click', '#saveAwayTeamChoise', ->
    $('#container').html(templates.endEvent())
  )

  $('#container').on('click', '#saveChoises', ->
    $(@).html('...')
    registry.sync(->
      registry.setCurrentGame(null)
      location.reload()
    )
  )
    #--               --#

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
    $('#container').html(templates.events())
  )
  #=========================================================================================================#
  #=========================================================================================================#
  #=========================================================================================================#

  registry.load()
  if !localStorageRead('loggedIn')
    $('#container').html(templates.login())
  else if !registry.currentGame?
    $.ajax(
      url: '/matches'
      method: 'GET'
      success: (matches) ->
        $('#container').html(templates.matches(matches))
      error: (err) -> refSessionExpired()
    )
  else if !registry.currentGame.ended?
    $('#container').html(templates.events())
  else
    $('#container').html(templates.endEvent())
