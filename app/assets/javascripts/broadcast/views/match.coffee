class Broadcast.Views.Match extends Backbone.View
  template: HoganTemplates['backbone/templates/match']

  initialize: ->
    @model = new Broadcast.Models.Match id: @match_id
    @listenTo @model, 'change:events', @render
    @model.fetch
    @listenTo Broadcast.Dispatcher, 'broadcast:message:new', @handle

  handle: (message) ->
    @model.update_score message.event if message.event.goal?

  render: ->
    @$el.prepend @template.render @model.toJSON()
