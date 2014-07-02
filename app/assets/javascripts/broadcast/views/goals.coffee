class Broadcast.Views.Goals extends Backbone.View
  el: '.goals-js'
  template: HoganTemplates['broadcast/templates/goal']

  initialize: ->
    @listenTo @collection, 'add',    @addOne
    @listenTo @collection, 'remove', @removeOne
    @render()

  addOne: (model)->
    if model.get('event')?.goal?
      @$el.append(@template.render(model.toJSON()))

  removeOne: (model) ->
    @render()

  render: ->
    @$el.empty()
    @collection.forEach @addOne, @