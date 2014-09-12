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


    game: (game) ->
      """
<div id="homeTeam" class="protocol">
    <nav class="navbar navbar-default" role="navigation">
            <div class="navbar-header">
                <a class="navbar-brand">#{game.homeTeam.name}: состав</a>
            </div>
      </nav>
  #{( "<button class='btn btn-block btn-default player homePlayer' id='#{id}' >#{p.number} #{p.name}</button>" for id, p of game.homeTeam.players).join('')}
  <button class='btn btn-block btn-success'  id="saveHomeTeamBtn">OK</button>
</div>

<div id="awayTeam" style='display: none' class="protocol">
      <nav class="navbar navbar-default" role="navigation">
            <div class="navbar-header">
                <a class="navbar-brand">#{game.awayTeam.name}: состав</a>
            </div>
      </nav>
  #{("<button class='btn btn-block btn-default player awayPlayer'  id='#{id}'>#{p.number} #{p.name}</button>" for id, p of game.awayTeam.players).join('')}
  <button class='btn btn-block btn-success' id="saveAwayTeamBtn">OK</button>
</div>
"""

    events: () ->
      """
      <nav class="navbar navbar-default" role="navigation">
            <div class="navbar-header">
                <a class="navbar-brand"> #{registry.currentGame.homeTeam.name} #{registry.currentGame.homeTeam.score}-#{registry.currentGame.awayTeam.score} #{registry.currentGame.awayTeam.name}</a>
            </div>
      </nav>
  <button class="btn btn-block btn-info event" id="goalEvent">Гол</button><br>
  <button class="btn btn-block btn-info event" id="yellowEvent">Жёлтая карточка</button><br>
  <button class="btn btn-block btn-info event" id="redEvent">Прямая красная</button><br>
  <button class="btn btn-block btn-success event" id="endEvent">Конец матча</button><br>
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
          <h2>#{registry.currentGame.homeTeam.name}</h2>
          #{("<button id='#{id}' class='btn btn-default playerEvent'>#{pl.number}
            <span class='goals'>#{if pl.goals? then pl.goals else 0}</span>
            <span class='assists'>#{if pl.assists? then pl.assists else 0}</span>
          </button> " for id, pl of registry.currentGame.homeTeam.players).join('')}
          <h2>#{registry.currentGame.awayTeam.name}</h2>
          #{("<button id='#{id}' class='btn btn-default playerEvent'>#{pl.number}
              <span class='goals'>#{if pl.goals? then pl.goals else 0}</span>
              <span class='assists'>#{if pl.assists? then pl.assists else 0}</span>
            </button> " for id, pl of registry.currentGame.awayTeam.players).join('')}
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
        #{("<button id='#{id}' class='btn btn-default playerEvent #{if pl.yellow is 2 then "btn-selected-red" else if pl.yellow is 1 then "btn-selected-yellow" else ""}'>#{pl.number}</button> " for id, pl of registry.currentGame.homeTeam.players).join('')}
        <h4>Wimbledon</h4>
        #{("<button id='#{id}' class='btn btn-default playerEvent #{if pl.yellow is 2 then "btn-selected-red" else if pl.yellow is 1 then "btn-selected-yellow" else ""}'>#{pl.number}</button> " for id, pl of registry.currentGame.awayTeam.players).join('')}

      <br><br><button class="btn btn-block btn-success" id="saveEvent">OK</button>
      </span>
"""

    redEvent: ->
      console.log registry.currentGame.homeTeam.players
      """
      <span id='red'>
      <nav class="navbar navbar-default" role="navigation">
        <div class="navbar-header">
          <a class="navbar-brand">Прямая красная</a>
        </div>
      </nav>
        <h4>Millwall</h4>
        #{("<button id='#{id}' class='btn btn-default playerEvent #{if pl.red is 1 then "btn-selected-red" else ""}'>#{pl.number}</button> " for id, pl of registry.currentGame.homeTeam.players).join('')}
        <h4>Wimbledon</h4>
        #{("<button id='#{id}' class='btn btn-default playerEvent #{if pl.red is 1 then "btn-selected-red" else ""}' >#{pl.number}</button> " for id, pl of registry.currentGame.awayTeam.players).join('')}

      <br><br><button class="btn btn-block btn-success" id="saveEvent">OK</button>
      </span>
"""



    endEvent: ->
        """
      <button class="btn btn-block btn-info" id="homeTeamChoise">выбор<br>#{registry.currentGame.homeTeam.name}</button> <br>
      <button class="btn btn-block btn-info"  type="button" id="awayTeamChoise">выбор<br>#{registry.currentGame.awayTeam.name}</button> <br>
      <button class="btn btn-block btn-success" id="saveChoises">OK</button>
"""

    choise: (side) ->
      players = []
      if side is 'Home'
        players = registry.currentGame.awayTeam.players
        team = registry.currentGame.homeTeam
      else
        players = registry.currentGame.homeTeam.players
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
    if game then @currentGame.homeTeam.score = @currentGame.awayTeam.score = 0
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
    if @currentGame.homeTeam.players[id]?
      delete @currentGame.homeTeam.players[id].star
    else
      delete @currentGame.awayTeam.players[id].star
    @save()

  registry.setBestPlayer = (id) ->
    if @currentGame.homeTeam.players[id]?
      @currentGame.homeTeam.players[id].star = true
    else
      @currentGame.awayTeam.players[id].star = true
    @save()

  registry.setPlayerActivity = (id, isActive) ->
    if @currentGame.homeTeam.players[id]?
      @currentGame.homeTeam.players[id].played = isActive
    else
      @currentGame.awayTeam.players[id].played = isActive
    @save()

  #todo эти четыре метода сжать в один сеттер

  registry.setPlayerGoals = (id, goals) ->
    if @currentGame.homeTeam.players[id]?
      @currentGame.homeTeam.players[id].goals = goals
    else
     @currentGame.awayTeam.players[id].goals = goals

    @currentGame.homeTeam.score = @currentGame.awayTeam.score = 0
    @currentGame.homeTeam.score += parseInt(pl.goals) for id, pl of @currentGame.homeTeam.players when pl.goals?
    @currentGame.awayTeam.score += parseInt(pl.goals) for id, pl of @currentGame.awayTeam.players when pl.goals?

    @save()


  registry.setPlayerAssists = (id, assists) ->
    if @currentGame.homeTeam.players[id]?
      @currentGame.homeTeam.players[id].assists = assists
    else
     @currentGame.awayTeam.players[id].assists = assists
    @save()

  registry.setPlayerYellow = (id, yellow) ->
    if @currentGame.homeTeam.players[id]?
      @currentGame.homeTeam.players[id].yellow = yellow
    else
      @currentGame.awayTeam.players[id].yellow = yellow
    @save()

  registry.setPlayerRed = (id, red) ->
    if @currentGame.homeTeam.players[id]?
      @currentGame.homeTeam.players[id].red = red
    else
      @currentGame.awayTeam.players[id].red = red
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
  #=========================================#



