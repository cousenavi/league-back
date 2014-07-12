process.env.NODE_ENV = process.env.NODE_ENV?.toLocaleLowerCase() ? 'dev'

class Config
  port: 80

class Config.dev extends Config
  port: 3000
  db: 'mongodb://localhost/dev'

class Config.test extends Config.dev
  port: 3001
  db: 'mongodb://localhost/test'

class Config.prod extends Config
  port: process.env.NODE_PORT
  db:   process.env.NODE_MONGO

module.exports = new Config[process.env.NODE_ENV]()
