$ ->
  #----------------------- COMMON BLOCK -----------------#
  setCookie = (name, value, options) ->
    options = {} if !options?
    value = encodeURIComponent(value)
    cookie = "#{name}=#{value}"
    for key, value of options
      cookie += "; #{key}=#{value}"
    document.cookie = cookie

  getCookie = (name) ->
   kvs = (keyval.split('=') for keyval in document.cookie.split('; '))
   (kv[1] for kv in kvs when kv[0] is name)[0]

  #------------------------------------------------------------#

  $.getJSON('/leagues', (leagues) ->
    html = ''
    for league in leagues
      html += "<option value='#{league._id}' #{if getCookie('leagueId') is league._id then 'selected' else ''}>#{league.name}</option>"

    $('#leaguesSelect').html(html)

    $('#leaguesSelect').on('change', ->
      setCookie('leagueId', @value)
      $(@).parent().find('[data-value=leagueName]').val( $(@).find('option:selected').html() )
      loadTeams(@value)
    );

    $('#leaguesSelect').change()
  )

  loadTeams = (leagueId) ->
    #todo добавить кеширование
    $.getJSON "/teams?leagueId=#{leagueId}", (teams) ->
     html = ''
     for team in teams
       html += """
                <tr id='#{team._id}'>
                  <td class="col-md-1" style="text-align: center">
                    <img src="/#{team.logo}"  height="50px">
                  </td>
                  <td class="col-md-10">
                    <span style="font-size: 18pt">#{team.name}</span>
                    <br><b>Лига:</b> #{team.leagueName}
                  </td>
                  <td class="col-md-1">
                    <button type="button" class="close delBtn" id="#{team._id}">×</button>
                  </td>
                </tr>
"""
     $('#list').html(html)

  $('#addBtn').click( (e) ->
    model = exportData $('#controlPanel')
    #todo temp
    model.logo = model.logo || 'leagues/portugal/logo/'+model.name+'.png'
    $.post( '/teams/add',model, -> location.reload())
  )

  $('body').on('click', '.delBtn', ->
    if confirm('удалить команду?')
       id = $(@).attr('id')
       $.post( '/teams/del',{_id: id}, -> location.reload())
  )

  exportData = ($el) ->
    data = {}
    $el.find('[data-value]').each((k, e) ->
      data[$(e).attr('data-value')] = $(e).val()
    )
    return data