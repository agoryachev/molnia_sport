#= require_self
#= require_tree ./config
#= require_tree ./utils
#= require_tree ./templates
#= require_tree ./controllers
#= require_tree ./models
#= require_tree ./views


window.CommentsApp =
  Models: {}
  Collections: {}
  Controllers: {}
  Views: {}
  Utils: {}
  CurrentUser: {}
  Messages: {
    not_authorized: 'Необходимо авторизоваться'
  }
  Vent: _.clone(Backbone.Events)