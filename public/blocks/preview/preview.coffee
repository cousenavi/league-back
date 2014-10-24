( ($) ->
  templates =

    form: (form) ->
      formHtml = ''
      for res in form.slice(-5)
        color = (if res is 'w' then 'green' else if res is 'd' then 'yellow' else 'red')
        formHtml +=  "<i class='circle #{color}'></i>"
      formHtml


    preview: (pr) ->
      """
<div id='prv'>
    <div id='head'>
        <div id='leagueName'>Amateur Portugal League</div><div id='tourNumber'>тур №#{pr.tourNumber}</div>
    </div>

    <table>

    <tbody><tr class='logo'>
        <td><img src="/#{pr.teams[0].logo}" ><br>#{pr.teams[0].name}</td>
        <td>
        </td>
        <td><img src="/#{pr.teams[1].logo}" ><br>#{pr.teams[1].name}</td>
    </tr>
    <tr><td></td><td>&nbsp;</td><td></td></tr>
    <tr class='position'>
        <td><div>#{pr.teams[0].position}</div></td>
        <td>позиция</td>
        <td><div>#{pr.teams[1].position}</div></td>
    </tr>
    <tr>
        <td><progress max="#{pr.teams[0].played}" value="#{pr.teams[0].won}" class="r green"></progress></td>
        <td>победы</td>
        <td><progress max="#{pr.teams[1].played}" value="#{pr.teams[1].won}" class="l green"></progress></td>
    </tr>
    <tr>
        <td><progress max="#{pr.teams[0].played}" value="#{pr.teams[0].draw}" class="r yellow"></progress></td>
        <td>ничьи</td>
        <td><progress max="#{pr.teams[1].played}" value="#{pr.teams[1].draw}" class="l yellow"></progress></td>
    </tr>
    <tr>
        <td><progress max="#{pr.teams[0].played}" value="#{pr.teams[0].lost}" class="r red"></progress></td>
        <td>поражения</td>
        <td><progress max="#{pr.teams[1].played}" value="#{pr.teams[0].lost}" class="l red"></progress></td>
    </tr>

    <tr>
        <td>
            #{templates.form(pr.teams[0].form)}
        </td>
        <td>форма</td>
        <td>
           #{templates.form(pr.teams[1].form)}
        </td>
    </tr>

    <tr><td></td><td>&nbsp;</td><td></td></tr>

    <tr>
        <td><progress max="#{pr.maxScored}" value="#{pr.teams[0].scored}" class="r green"></progress></td>
        <!-- максимум забитых - лучший показатель команд в чемпе -->
        <td>забито</td>
        <td><progress max="#{pr.maxScored}" value="#{pr.teams[1].scored}" class="l green"></progress></td>
    </tr>

    <tr>
        <td><progress max="#{pr.maxConceded}" value="#{pr.teams[0].conceded}" class="r red"></progress></td>
        <td>пропущено</td>
        <td><progress max="#{pr.maxConceded}" value="#{pr.teams[1].conceded}" class="l red"></progress></td>
    </tr>
    <tr><td></td><td>&nbsp;</td><td></td></tr>
    <tr>
        <td>
            <div class="canvas-holder half">
                <canvas id="#{pr.gameId}_homeTeamChart" height="75" style=" height: 75px;"></canvas>
            </div>
        </td>
        <td>голеадоры</td>
        <td>
            <div class="canvas-holder half">
                <canvas id="#{pr.gameId}_awayTeamChart" height="75" style=" height: 75px;"></canvas>
            </div>
        </td>
    </tr>
</tbody></table>
        <div id='footer'>
            <div id='date'>#{pr.date}</div>
            <div id='time'>#{pr.time}</div>
            стадион "#{pr.placeName}"
        </div></div>
"""

  $.fn.preview = (leagueId) ->
    drawChart = (preview) ->
      options = {
        legendTemplate: "<% %><br><i class=\"circle small red\"></i> <%=segments[0].label%><br><i class=\"circle small yellow\"></i> <%=segments[1].label%><br><i class=\"circle small green\"></i> <%=segments[2].label%>",
        animation: false
      }
      data = ->
        [{color: '#cf0404'}, {color: '#febf04'}, {color: '#83c783'}, {color: '#ddd'},]

      data1 = new data()
      for pl, key in preview.teams[0].players
        data1[key].label =  pl.name+" (#{pl.goals})"
        data1[key].value = pl.goals
      data2 = new data()
      for pl, key in preview.teams[1].players
        data2[key].label =  pl.name+" (#{pl.goals})"
        data2[key].value = pl.goals

      console.log data1

      c1 = $('#'+preview.gameId+'_homeTeamChart').get(0).getContext('2d');
      chart1  = new Chart(c1).Pie(data1, options);
      $('#'+preview.gameId+'_homeTeamChart').parent().append(chart1.generateLegend());
      c2 = $('#'+preview.gameId+'_awayTeamChart').get(0).getContext('2d');
      chart2  = new Chart(c2).Pie(data2, options);
      $('#'+preview.gameId+'_awayTeamChart').parent().append(chart2.generateLegend());


    $.getJSON('/games?leagueId=54009eb17336983c24342ed9&ended=false', (games) =>
      for gm in games
        $.getJSON '/tables/game_preview?gameId='+gm._id, (preview) =>
          @.append templates.preview(preview)
          drawChart(preview)
    )

)(jQuery)
