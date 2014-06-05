assert = require 'assert'
supertest = require 'supertest'


config = require('./../config')('test')
app = require('./../app')(config)
host = 'http://localhost:'+config.port
request = supertest(host)

before (done)->
  server = app.listen config.port, ->
    app.mongoose.connection.on('open', ->
      app.mongoose.connection.db.dropDatabase((err) -> console.log err)
      done()
    )

describe '', ->
  it 'empty teams list', (done) ->
      request.get('/teams').expect(200).expect('[]').end(done)

  it 'non existing team', (done) ->
      request.get('/teams/Millwall').expect(404).end(done)

  it 'adding a team', (done) ->
      request.post('/teams_add').send(name: "Millwall", league: 1).expect(200).end(done)

  it 'adding the same team twice', (done) ->
      request.post('/teams_add').send(name: "Millwall", league: 1).expect(400).end(done)

  it 'teams list with one existing team', (done) ->
    request.get('/teams').expect(200).expect((res) ->
      if (res.body.length is 1) then false else 'teams quontity is incorrect'
    ).end(done)

  it 'get existing team then update it', (done) ->
      request.get('/teams/Millwall').expect(200).end((err, res) ->
        id = res.body.team._id
        request.post('/teams_update').send(_id: id, name: "Millwall", league: 0).expect(200).end((err, res) ->
          request.get('/teams/Millwall').expect(200, (err, res) ->
            if (res.body.team.league is 0) then false else "team league expected to be 0, #{res.body.team.league} received"
          ).end(done)
        )
      )
