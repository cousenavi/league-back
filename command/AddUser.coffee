process.env.NODE_ENV = 'dev'
config = require('./../config')
app = require('./../app')(config)

#user =  app.models.User(
#  role: 'root'
#  login: 'root'
#  password: 'sudosandwitch'
#).save()


app.models.User.findOneAndUpdate({login: 'root'}, {password: 's'})