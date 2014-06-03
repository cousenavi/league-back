assert = require 'assert'
supertest = require 'supertest'
host = 'http://localhost:3000'
request = supertest(host)

responseFormat = (exp, res) ->
  true

describe 'GET /teams',  ->
  it 'возвращает список команд', (done)->
      request.get('/teams').expect('Content-Type', /json/).expect(200,
        responseFormat({"name": "Millwall"}, ew)
      ).end((err, res) ->
        return done(err)
      )
