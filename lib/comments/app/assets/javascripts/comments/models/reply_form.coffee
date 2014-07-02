class CommentsApp.Models.ReplyForm extends Backbone.Model
  urlRoot: '/comments'

  defaults:
    commentable_type: ''
    commentable_id:   ''
    parent_id:        null
    content:          ''