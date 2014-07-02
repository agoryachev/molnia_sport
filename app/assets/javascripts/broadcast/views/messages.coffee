class Broadcast.Views.Messages extends Backbone.View
  el: '.event-wrap'

  template: HoganTemplates['broadcast/templates/message']

  initialize: ->
    @listenTo @collection, 'add',    @addOne
    @listenTo @collection, 'remove', @removeOne
    @render()

  addOne: (model) ->
    if model.get('message')?
      @$el.prepend @template.render model.toJSON()
      twttr.widgets?.load?()

  removeOne: (model) ->
    @render()

  render: ->
    @$el.empty()
    @collection.forEach @addOne, @
