config = require('./config')
app = require('./app')(config)

server = app.listen(config.port, ->  console.log 'started!')
