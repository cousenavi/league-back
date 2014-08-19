$ ->
  templates =

    player: (player) =>
      return """
        <tr>
          <input type='hidden' value="#{player._id}" data-value="_id">
          <input type='hidden' value="#{player.name}" data-value="name">
          <input type='hidden' value="#{player.position}" data-value="position">
          <input type='hidden' value="#{player.teamName}" data-value="teamName">
          <input type='hidden' value="#{player.teamId}" data-value="teamId">
          <input type='hidden' value="#{player.number}" data-value="number">
          <td>#{player.name}</td>

          <td>#{player.number}</td>
          <td>#{player.position}</td>
        </tr>
              """
    popup: (player, teams) =>
      return """
        <div class="modal">
          <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h4 class="modal-title">
                        #{if player.name? then 'Редактирование игрока' else 'Добавление игрока'}
                    </h4>
                </div>
                <div class="modal-body">
                   <input type="hidden" data-value="teamName" data-target='popupTeams'>
                  #{if player._id? then "<input type='hidden' data-value='_id' value='#{player._id}'>" else ""}

                   <select class="form-control" id="popupTeams" data-value="teamId">
#{ ("<option #{if player.teamId is team._id then 'selected' else ''} value='#{team._id}'>#{team.name}</option>" for team in teams).join('')}
                   </select><br>
                   <div class="row">
                     <div class="col-xs-8 col-md-8 col-lg-8">
                        <input type="text" class="form-control" data-value='name' value="#{if player.name? then player.name else ''}" tabindex=1>
                     </div>
                      <div class="col-xs-2 col-md-2 col-lg-2" >
                        <select class="form-control" id="positions" data-value="position" tabindex="2">
                             #{
"<option #{if pos is player.position then 'selected' else ''}>#{pos}</option> " for pos in ['GK', 'CB', 'RB', 'LB', 'CM', 'LM', 'RM', 'ST']
                             }
                        </select>
                      </div>
                      <div class="col-xs-2 col-md-2 col-lg-2" >
                        <input type="text" class="form-control" data-value='number' tabindex='3' value="#{if player.number? then player.number else ''}">
                      </div>
                </div>

                </div>
                <div class="modal-footer">
#{if !player.name? then '' else '<a class="btn btn-danger" id="btnDel" style="float:left">Удалить</a>' }
                  <button id="addPlayer" class="btn btn-success" tabindex=4>Сохранить</button>
                </div>
            </div>
          </div>
        </div>
"""

  loadPlayersHtml = (teamId) ->
    @cache = {} if !@cache?
    return new Promise((resolve, reject) =>
      if @cache[teamId]
        resolve(@cache[teamId])
      else $.getJSON("/players?teamId=#{teamId}", (players) =>
        html = (templates.player(pr) for pr in players).join('')
        @cache[teamId] = html
        resolve(@cache[teamId])
      )
    )

  $.when(
    $.getJSON('/leagues'),
    $.getJSON('/teams')
  ).then((leagues, teams) ->
    leagueId = getCookie('leagueId')
    $('#leagues').html(
      ("<option value='#{league._id}' #{if league._id is leagueId then 'selected' else '' }>#{league.name}</option>" for league in leagues[0])
    ).on('change', ->
      setCookie('leagueId', @value)
      teamId = getCookie('teamId')
      $('#teams').html(
        ("<option value='#{team._id}' #{if team._id is teamId then 'selected' else '' }>#{team.name}</option>" for team in teams[0] when team.leagueId is @value).join('')
      )
    )

    $('#teams').on('change', ->
      setCookie('teamId', @value)
      loadPlayersHtml(@value).then((html) ->
        $('#list').html(html)
      )
    )

    $('#leagues').change()
    $('#teams').change()

    $('#addBtn').on('click', ->
      $(templates.popup(teamId: $('#teams option:selected').val(), teams[0])).modal(show: true)
      $('.modal [data-value=name]').focus()
    )


    $('body').on('click', '#addPlayer',(e) ->
      model = exportData $(e.target).parent().parent().parent()
      if model._id?
        $.post('/players/upd', model, ->
          location.reload())
      else
        $.post('/players/add', model, ->
          location.reload())
    ).on('change', 'select', (e) ->
      name = $(e.target).find('option:selected').html()
      id = $(e.target).attr('id')
      $(e.target).parent().find("[data-target='#{id}']").val(name)
    )


    $('#list').on('click', 'tr', (e) ->
      model = exportData($(e.currentTarget))
      $(templates.popup(model, teams[0])).modal(show: true)
    )

    $('body').on('click', '#btnDel', (e) ->
      model = exportData($(e.currentTarget).parent().parent())
      $.post('/players/del', {_id: model._id}, ->
        location.reload())
    )

  )

  #todo вынести в общий файл наконец!!!
  exportData = ($el) ->
    data = {}
    $el.find('[data-value]').each((k, e) ->
      data[$(e).attr('data-value')] = $(e).val()
    )
    return data

  setCookie = (name, value, options) ->
    options = {} if !options?
    value = encodeURIComponent(value)
    cookie = "#{name}=#{value}"
    for key, value of options
      cookie += "; #{key}=#{value}"
    document.cookie = cookie

  getCookie = (name) ->
    console.log document.cookie
    kvs = (keyval.split('=') for keyval in document.cookie.split('; '))
    (kv[1] for kv in kvs when kv[0] is name)[0]
