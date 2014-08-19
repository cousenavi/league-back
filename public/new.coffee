$ ->
  loadBp = (leagueId) ->
    @cache = {} if !@cache?
    return new Promise((resolve, reject) =>
      if @cache[leagueId]
        resolve(@cache[leagueId])
      else
        $.getJSON("/tables/best_players?leagueId=#{leagueId}", (bp) =>
          html = options: '', field: '', players: ''
          for key, val of bp
            fhtml = "<div id='#{key}'>"
            phtml = "<table id='#{key}'><thead><th></th><th>G</th><th>A</th><th><span class='glyphicon glyphicon-star'></span></th></thead>"
            for pos, pl of val.players[0]
              console.log pl
              fhtml += """
                  <div class="player #{pl.position}">
                        <img src="#{pl.teamLogo}"><br>
                        #{pl.name}
                    </div>
                          """
              phtml += """
                <tr>
                    <td>#{pl.name}</td>
                    <td>#{if pl.position is 'GK' then (0 - pl.conceeded) else pl.goals}</td><td>#{pl.assists}</td>
                    <td>#{if pl.star then "<span class='glyphicon glyphicon-star'></span>" else ""}</td>
                  </tr>
"""
            fhtml += '</div>'
            phtml += '</table>'

            html.options += """
              <option>#{key}</option>
  """
            html.field += fhtml
            html.players += phtml

          @cache[leagueId] = html
          resolve(@cache[leagueId])
        )
    )

  $.getJSON('leagues', (leagues) ->
    $('#leagues').html(
      ("<option value='#{league._id}'>#{league.name}</option>" for league in leagues).join('')
    ).on('change', ->
        loadBp(@value).then((html) ->
          $('#fieldsCache').html(html.field)
          $('#playersCache').html(html.players)
          $('#tours').html(html.options).change()
        )
    ).change()

    $('#tours').change( ->
      console.log  $('#playersCache').find('#'+$(@).val()).html()

      $('#field').html( $('#fieldsCache').find('#'+$(@).val()).html() );
      $('#players').html( $('#playersCache').find('#'+$(@).val()).html() );
    )
  )
