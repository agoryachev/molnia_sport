class Broadcast.Views.Scores extends Backbone.View
  el: '.score-js'

  initialize: ->
    @listenTo @collection, 'add',    @addOne
    @listenTo @collection, 'remove', @removeOne
    @render()

  addOne: (model)->
    if model.get('event')?.goal?
      @updateScore(model)

  removeOne: (model) ->
    @render()

  updateScore: (model) ->
    @$el.find('.count-home-js').html  model.get('event').count_home + ':'
    @$el.find('.count-guest-js').html model.get('event').count_guest

  render: ->
    @collection.forEach @addOne, @
