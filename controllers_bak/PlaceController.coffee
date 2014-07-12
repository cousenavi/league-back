AbstractCrudController = require './AbstractCrudController'

module.exports = class PlaceController extends AbstractCrudController
  constructor: ->
    @pathToModel =  './../models/Place'
