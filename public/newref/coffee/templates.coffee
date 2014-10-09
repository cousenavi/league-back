window.templates.menu = (text, backId, refreshId, subCaption) ->
  html = '<nav class="navbar navbar-default" role="navigation">'
  if backId? then html += "<a id='#{backId}' class='glyphicon glyphicon-arrow-left navbar-button navbar-left' ></a>"
  html += "<span>#{text}</span>"
  if refreshId? then html += "<a id='#{refreshId}' class='glyphicon glyphicon-refresh navbar-button navbar-right' ></a>"
  html += '</nav>'

#=============================================================================#
#невидимый контейнер с лоадером
window.templates.ajaxLoader =  '<div class="ajaxLoad"><img src="/img/sprite/ajax-loader.gif"></div>'
#=============================================================================#

window.templates.login = -> """
    <div id="loginForm">
    <input type="text" data-value="login" class="form-control" placeholder='login'  #{ if login = getCookie('login') then "value=\"#{login}\"" else '' }><br>
    <input type="password" data-value="password" class="form-control" placeholder='password'><br>
    <button id="loginBtn" class="btn btn-success btn-block">Go!</button>
  </div>
"""

$('#container').on 'click', '#loginBtn', ->
  model = extractData($(@).parent())
  setCookie('login', model.login)
  view.actionLogin(model)

#==============================================================================#

window.templates.games = (games) ->
  html = templates.menu('Выберите матч', 'logout', 'refreshGames')
  html += templates.ajaxLoader
  html += ("<button class='btn btn-block btn-info match' id='#{m._id}'class='match'>#{m.teams[0].name} <br> #{m.teams[1].name}<br><span class='smallText'>#{m.date} #{if m.time? then m.time else ''} #{if m.placeName? then m.placeName else ''}</span></button><br>" for key, m of games).join('')

$('#container').on 'click', '.match', ->
  view.viewGame($(@).attr('id'))

$('#container').on 'click', '#logout', ->
  view.actionLogout()

$('#container').on 'click', '#refreshGames', ->
  $('.ajaxLoad').show()
  view.actionLoadGames()
#==============================================================================#

window.templates.game = (game) ->
  menuCaption = game.teams[0].score+':'+game.teams[1].score
  html = templates.menu(menuCaption, 'toGamesList', 'refreshGame')
  html += templates.ajaxLoader
  html += "<input type='hidden' id='gameId' value='#{game._id}'>"
  html += """
  <button class='btn btn-block btn-info' id="toProtocol" data-side="home">#{game.teams[0].name} - протокол</button>
  <button class='btn btn-block btn-info' id="toProtocol" data-side="away">#{game.teams[1].name} - протокол</button>
  <button class='btn btn-block btn-info' id="homeChoise">#{game.teams[0].name} - выбор</button>
  <button class='btn btn-block btn-info' id="awayChoise">#{game.teams[1].name} - выбор</button>
  <button class='btn btn-block btn-success' id="endMatch">завершить матч</button>
"""

$('#container').on 'click', '#toGamesList', ->
  view.viewLoadedGamesList()

$('#container').on 'click', '#refreshGame', ->
  $('.ajaxLoad').show()
  id = $('#gameId').val()
  view.actionLoadGame(id)

$('#container').on 'click', '#toProtocol', ->
  id = $('#gameId').val()
  side = $(@).attr('data-side')
  view.viewRoster(id, side)

$('#container').on 'click', '#endMatch', ->
  if confirm 'Завершить матч? Это действие нельзя отменить'
    id = $('#gameId').val()
    view.actionEndGame(id)

#==============================================================================#

window.templates.roster = (gameId, side, team) ->
  formatPlayerName =  (name) ->
    #todo возможно, стоит проверять, есть ли в команде однофамильцы и тогда выводить имя, но, наверное, номера и фамилии достаточно
    return name.split(' ')[0]

  html = templates.menu(team.name, 'toGame', 'refreshRoster')
  html += templates.ajaxLoader
  html += "<input type='hidden' id='gameId' value='#{gameId}'>"
  html += "<input type='hidden' id='side' value='#{side}'>"
  html += """
<div class="control-panel">
  <img class='btn btn-logo active' id="playedBtn" src="/img/sprite/foot/shirt.png">
  <img class='btn btn-logo' id="goalBtn" src="/img/sprite/foot/ball.png">
  <img class='btn btn-logo' id="passBtn" src="/img/sprite/foot/assist.png">
  <img class='btn btn-logo' id="yellowBtn" src="/img/sprite/foot/yellow_card.png">
  <img class='btn btn-logo' id="redBtn" src="/img/sprite/foot/red_card.png">
  <img class='btn btn-logo' id="undoBtn" src="/img/sprite/foot/undo.png">
</div><br>
"""

  html += '<div class="roster">'
  for pl in team.players
    html += "<button class='btn btn-block btn-default player #{if pl.played then '' else 'out'}' id='#{pl._id}'>
               <span class='number'>#{pl.number}</span>
               <span class='name'>#{formatPlayerName(pl.name)}</span>
               <div>
     #{'<img style="height: 25px" src="/img/sprite/foot/ball.png">'.repeat(pl.goals)}
#{'<img style="height: 25px" src="/img/sprite/foot/assist.png">'.repeat(pl.assists)}
#{if pl.yellow is 1 then '<img style="height: 25px" src="/img/sprite/foot/yellow_card.png">' else if pl.yellow is 2 then '<img style="height: 25px" src="/img/sprite/foot/red_card_2yellow.png">' else '' }
#{if pl.red is 1 then  '<img style="height: 25px" src="/img/sprite/foot/red_card.png">' else '' }
    </div>
                     </button>"

  html += '</div>'

pressButton = (target) ->
  $(target).parent().find('.btn').each(-> $(@).removeClass('active'))
  $(target).addClass('active')

setMode = (mode) ->
  window.mode = mode

$('#container').on 'click', '#playedBtn', ->
  pressButton(@)
  setMode('played')

$('#container').on 'click', '#goalBtn', ->
  pressButton(@)
  setMode('goal')

$('#container').on 'click', '#passBtn', ->
  pressButton(@)
  setMode('assist')

$('#container').on 'click', '#yellowBtn', ->
  pressButton(@)
  setMode('yellow')

$('#container').on 'click', '#redBtn', ->
  pressButton(@)
  setMode('red')

$('#container').on 'click', '#undoBtn', ->
  gameId = $('#gameId').val()
  side = $('#side').val()
  view.actionUndo(gameId, side)

setPlayerStats = ($pl, key, value) ->
  id = $pl.attr('id')
  gameId = $('#gameId').val()
  side = $('#side').val()
  view.actionSetPlayerStats(gameId, side, id, key, value)

$('#container').on 'click', '.player', ->
  $(@).attr('disabled', true)
  if mode is 'played'   
    played = $(@).hasClass('out') #если сейчас стоит признак, что не играл, значит после изменения будет играющий
    setPlayerStats($(@), 'played', played)

  if mode is 'goal'
    setPlayerStats($(@), 'played', true)
    setPlayerStats($(@), 'goals', {$inc: 1})
    view.actionIncrementScore($('#gameId').val(), $('#side').val())

  if mode is 'assist'
    setPlayerStats($(@), 'played', true)
    setPlayerStats($(@), 'assists', {$inc: 1})
  if mode is 'yellow'
    setPlayerStats($(@), 'played', true)
    setPlayerStats($(@), 'yellow', {$inc: 1})
  if mode is 'red'
    setPlayerStats($(@), 'played', true)
    setPlayerStats($(@), 'red', {$inc: 1})

$('#container').on 'click', '#refreshRoster', ->
  $('.ajaxLoad').show()
  id = $('#gameId').val()
  side = $('#side').val()
  view.actionLoadRoster(id, side)

$('#container').on 'click', '#toGame', ->
  id = $('#gameId').val()
  view.viewGame(id)
