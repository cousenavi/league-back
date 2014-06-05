config =
  test:
    db: 'mongodb://localhost/test'
    port: 3001

  dev:
    db: 'mongodb://localhost/dev'
    port: 3000


module.exports = (mode) ->
  return config[mode]