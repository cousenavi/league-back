module.exports = (userRoles, requiredRole) ->
  if userRoles.indexOf('root') >= 0 then return true
  if userRoles.indexOf('admin') >= 0 and requiredRole isnt 'root' then return true else return false
  return userRoles.indexOf(requiredRole) >= 0
