args = require('minimist')(process.argv.slice(2))
env = args['env']

config = require('./config')(env)

app = require('./app')(config)

server = app.listen(config.port, ->  console.log 'started')


