class Broadcast.Views.BroadcastView extends Backbone.View
  initialize: ->
    # @listenTo @model, 'change', @render, @
    # @model.fetch()
    # @messages = new Broadcast.Views.BroadcastMessages
    # @timeline = new Broadcast.views.BroadcastTimeline

  process: (data) ->
    Broadcast.Dispatcher.trigger 'broadcast:message:new', data

  render: ->
    score = new Broadcast.Models.Score(@model.get('events').last())
    new Broadcast.Views.Scores({model: score})