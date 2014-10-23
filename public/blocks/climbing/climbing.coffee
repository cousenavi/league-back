#settings =
#  chart: type: 'spline'
#  title: text: '  Динамика набора очков командами'
#  plotOptions:
#    spline:
#      lineWidth: 4
#      marker: enabled: false
#      states: hover: lineWidth: 5
#  yAxis: title: {text: 'очки'}, floor: 0, gridLineWidth: 0,  allowDecimals: false
#  xAxis: title: {text: 'матчи'}, floor: 0, allowDecimals: false
#
#
#loadSeries = (leagueId) ->
#  @cache = {} if !@cache?
#  return new Promise((resolve, reject) =>
#    if @cache[leagueId]
#      resolve(@cache[leagueId])
#    else
#      $.getJSON('/tables/climbing_chart', {leagueId: leagueId}, (series) =>
#        @cache[leagueId] = series
#        resolve(@cache[leagueId])
#      )
#  )
#
#$ ->
#  chart = $("""
#    <div></div>
#""")
#  selector = $('<div></div>')
#
#  loadSeries('53c55cff737e7c9a0ef19cdd').then((chart) ->
#    console.log     settings.series = chart.series
#    element.highcharts(settings)
#    element.appendTo('body')
#
#    for sr in chart.series
#      selector.append("<input type='checkbox' "")
#  )


