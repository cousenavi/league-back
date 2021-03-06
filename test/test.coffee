assert = require 'assert'
supertest = require 'supertest'

process.env.NODE_ENV = 'test'
config = require('./../config')
app = require('./../app')(config)
host = 'http://localhost:'+config.port
request = supertest.agent(host)

fixture = (mongoose, done) ->
  done()
#  User = require './../models/User'
#  (new User({email: "root", password: "root", roles: ["root"]})).save (err) ->
#    if err then trhow err else done()

before (done)->
  server = app.listen config.port, ->
    app.mongoose.connection.on('open', ->
      app.mongoose.connection.db.dropDatabase((err) ->
        throw err if err
        fixture(app.mongoose, done)
      )
    )

#describe 'auth', ->
#  it 'login', (done) ->
#    request.post('/login').send(email: "root", password: "root").expect(200, roles: ['root']
#    ).end(done)
#
#  it 'users_add', (done) ->
#    request.post('/users_add').send(email: 'user', password: 'user').expect(200).end(done)
#
#  it 'users', (done) ->
#    request.get('/users').expect(200)
#    .expect((res) ->
#        if res.body.length is 2 then false else 'incorrect number of users'
#      ).end( (err, res) ->
#        if err then done(err)
#        id = res.body[0]._id
#        request.post('/users_update').send(_id: id, roles: ["root", "newRoles"]).expect(200).end(done)
#    )
#
#  it 'logout', (done) ->
#    request.get('/logout').expect(200).end( (err, res) ->
#      if err then done(err)
#      request.get('/users').expect(403).end(done)
#    )
#
#  it 'yet another login to work with protected methods', (done) ->
#    request.post('/login').send(email: "root", password: "root").expect(200).end(done)
#
#
#describe 'teams', ->
#  it 'empty teams list', (done) ->
#    request.get('/teams').expect(200).expect('[]').end(done)
#  it 'non existing team', (done) ->
#    request.get('/teams/Millwall').expect(404).end(done)
#
#  it 'adding a team', (done) ->
#    request.post('/teams_add').send(name: "Millwall", league: 1).expect(200).end(done)
#
#  it 'adding the same team twice', (done) ->
#    request.post('/teams_add').send(name: "Millwall", league: 1).expect(400).end(done)
#
#  it 'teams list with one existing team', (done) ->
#    request.get('/teams').expect(200).expect((res) ->
#      if (res.body.length is 1) then false else 'teams quontity is incorrect'
#    ).end(done)
#
#  it 'get existing team then update it', (done) ->
#    request.get('/teams/Millwall').expect(200).end((err, res) ->
#      id = res.body.team._id
#      request.post('/teams_update').send(_id: id, name: "Millwall", league: 0).expect(200).end((err, res) ->
#        request.get('/teams/Millwall').expect(200).expect( (res) ->
#          if (res.body.team.league is "0") then false else "team league expected to be 0, #{res.body.team.league} received"
#        ).end((err, res) ->
#          request.post('/teams_delete').send(_id: id).expect(200).end( (err, res) ->
#            request.get('/teams').expect(200).expect('[]').end(done)
#          )
#        )
#      )
#    )

#describe 'players', ->
#  it 'players', (done) ->
#    request.get('/players').expect(200).end(done)
#
#  it 'add player', (done) ->
#    request.post('/players_add').send(name: "Cousen Avi", team: "Millwall").expect(200).end((err, res) ->
#      id = res._id
#      request.post('/players_update').send(_id: id).expect(200).end((err, res) ->
#        request.post('/players_delete').send(_id: id).expect(200).end(done)
#      )
#    )

#describe 'places', ->
#  it 'places', (done) ->
#    request.get('/places').expect(200).end(done)
#
#

describe 'referees', ->
  it 'referees', (done) ->
    request.get('/referees').expect(200).end(done)

  it 'referees_add', (done) ->
    request.post('/referees/add').send(name: 'test', photo: '').expect(200).end(done)