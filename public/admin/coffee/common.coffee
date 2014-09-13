window.templates =

  error: (errorText) -> """
<div class="alert alert-danger" role="alert">#{errorText}</div>
"""

  popup: (head, content, footer) -> """
<div class="modal active" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title">#{head}</h4>
      </div>
      <div class="modal-body">#{content}</div>
      <div class="modal-footer">#{footer}</div>
    </div>
  </div>
</div>
"""
  hiddenModel: (model) ->
    html = ''
    for key, value of model
      html += "<input type='hidden' data-value='#{key}' value='#{value}'>"
    return html




#-------------------------------------#
window.request = (options) ->
  $.ajax(
    url: options.url,
    data: options.params || {},
    method: options.method || 'GET',
    success: options.success,
    error: options.error || (error) ->
      console.log error
      $('#container .alert-danger').remove()
      $('#container').prepend(window.templates.error(error.responseText))
  )

window.extractData = ($el) ->
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

window.setCookie = (name, value, options) ->
  options = {} if !options?
  value = encodeURIComponent(value)
  cookie = "#{name}=#{value}"
  for key, value of options
    cookie += "; #{key}=#{value}"
  document.cookie = cookie

window.getCookie = (name) ->
  kvs = (keyval.split('=') for keyval in document.cookie.split('; '))
  (kv[1] for kv in kvs when kv[0] is name)[0]


window.sessionExpired = () ->
  localStorage.setItem('user', null)
  location.href = '/admin'

window.localStorageRead = (key) ->
  val = localStorage.getItem(key)
  if val? && val isnt 'undefined'
    return JSON.parse(val)
  else return null
#---------------------------------------------------------#

$('body').on('click', '.modal .btn', ->
  $('.modal').hide()
  $('#container').html('')
)
