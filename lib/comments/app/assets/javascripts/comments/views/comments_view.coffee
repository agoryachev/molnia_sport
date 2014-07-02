class CommentsApp.Views.CommentsView extends Backbone.View

  initialize: (opts)->
    @childViews = []
    {@type, @id} = opts
    @listenTo CommentsApp.Vent, 'new:comment', @addComment
    @listenTo CommentsApp.Vent, 'filter:comments', @filterComments
    @listenTo @collection, 'reset', @render
    @listenTo @collection, 'sorted', @render
    @render()

  filterComments: (filter)-> @collection[filter]()


  addComment: (commentModel)->
    v = new CommentsApp.Views.CommentView({model: commentModel, @type, @id})
    @collection.fetch
      reset: true
      data: {@type, @id}

  render: ->
    @$el.empty()
    @collection.forEach (comment)=> @addOne(comment)
    @

  addOne: (comment)->
    v = new CommentsApp.Views.CommentView({model: comment, @type, @id})
    @childViews.push v
    @$el.append(v.render().el)