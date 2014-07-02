class CommentsApp.Views.ReplyFormView extends Backbone.View
  replyFormName: 'reply-form'
  replyFormFields: ['commentable_type', 'commentable_id', 'parent_id', 'content']
  emptyFieldsAfterSubmit: ['content']
  template: HoganTemplates['comments/templates/reply_form']

  events:
    'click input[type=submit]': 'newComment'

  initialize: (opts)->
    {@type, @id, @parent_id} = opts
    @render()

  newComment: (e)->
    e.preventDefault()
    e.stopPropagation()
    return showErrors(CommentsApp.Messages.not_authorized) unless CommentsApp.CurrentUser.get('id')

    # TODO переписать все красиво на модель коммент
    new CommentsApp.Models.Comment(@getReplyFormData())
    .save()
    .success (comment)=>
      commentModel = new CommentsApp.Models.Comment(comment.comment)
      @emptyFields()
      CommentsApp.Vent.trigger 'new:comment', commentModel
      showNotices(comment.msg)
    .error ()->

  getReplyFormData: ->
    # TODO надо как то закешировать форму
    form = document.forms[@replyFormName]
    obj = {}
    for fieldName in @replyFormFields when form[fieldName]?
      return showErrors(CommentsApp.Messages.emptyComment) if form[fieldName].value is ''
      obj[fieldName] = form[fieldName].value
    obj

  emptyFields: ->
    # TODO надо как то закешировать форму
    form = document.forms[@replyFormName]
    form[fieldName].value = '' for fieldName in @emptyFieldsAfterSubmit when form[fieldName]?


  render: ->
    @$el.html(@template.render({@type, @id, @parent_id, text: CommentsApp.ViewText}))
    @
