$ ->
  $.getJSON('/tables/simple_table', {}, (table) ->
    console.log 'ok', table
  )