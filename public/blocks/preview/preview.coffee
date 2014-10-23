( ($) ->
  templates =
    preview: () ->
      "<progress max='100' value='10'></progress>"

  $.fn.preview = (leagueId, homeTeamId, awayTeamId) ->
    @.html templates.preview()

)(jQuery)
