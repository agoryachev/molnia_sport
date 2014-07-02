class CommentsApp.Views.CommentView

  constructor: ->
    _.extend @, Backbone.Events
    @listenTo CommentsApp.Vent, 'show:comments', @showComments

  showComments: (type, id, category_id)->
    type = _.classify(_.singularize(type))
    return unless type in CommentsApp.Config.enableFor

    CommentsApp.CurrentUser = new CommentsApp.Models.CurrentUser
    CommentsApp.CurrentUser.fetch()

    comments = new CommentsApp.Collections.Comments

    comments.fetch
      data: {type, id}
      success: (comments)=>
        new CommentsApp.Views.CommentsView({
          type, id, collection: comments, el: CommentsApp.Config.commentsSection
        })
    replyForm = new CommentsApp.Views.ReplyFormView({type, id})
    $(CommentsApp.Config.replyFormSection).html(replyForm.render().el)


new CommentsApp.Views.CommentView