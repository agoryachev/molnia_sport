#= require_self
#= require_tree ./backbone_extends
#= require_tree ./templates
#= require_tree ./utils
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

#= require comments/comments_app


window.Sport =
  Models: {}
  Collections: {}
  Routes: {}
  Views: {}
  Utils: {}
  Vent: _.clone(Backbone.Events)

  init: ->
    Sport.initComments()
    new CommentsApp.Views.CommentsFilter
    new Sport.Routes.ApplicationRouter

    new Broadcast.Controllers.BroadcastController
    new Broadcast.Controllers.TeamsController
    Backbone.history.start(pushState: true)

  initComments: ->
    # Comments
    _.extend(CommentsApp, {
      Config:
        paddingLeft: 57
        depth: 3
        commentsSection: '.js-comments'
        replyFormSection: '.js-reply-form'
        enableFor: ['Video', 'Post', 'Gallery', 'ColumnistPost', 'Page', 'Match']
      ViewText:
        up: ''
        down: ''
        reply: 'Ответить'
        submitButton: 'Отправить'
      Messages:
        not_authorized: 'Надо авторизоваться'
        emptyComment:   'Надо заполнить поле комментария'
    })

$(document).ready ->
  Sport.init()
