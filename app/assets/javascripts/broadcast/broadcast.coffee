#= require_self
#= require_tree ./controllers
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views

window.Broadcast =
  Models: {}
  Collections: {}
  Controllers: {}
  Views: {}
  Dispatcher: _.clone(Backbone.Events)
  # Adapter: if window.EventSource? then SSEAdapter else AjaxAdapter
