window.BroadcastMessages =
  Models: {}
  Collections: {}
  Views: {}
  Controllers: {}
  Routes: {}
  Vent: _.extend Backbone.Events

  init: ->
    new BroadcastMessages.Routes.MainRoute
    new BroadcastMessages.Views.MessagesTimeline
    Backbone.history.start(pushState: true)

$ ->
  BroadcastMessages.init()