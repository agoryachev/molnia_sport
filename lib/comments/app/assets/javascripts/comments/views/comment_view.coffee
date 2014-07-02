class CommentsApp.Views.CommentView extends Backbone.View
  template: HoganTemplates['comments/templates/comment']
  tagName: 'article'
  className: "comment_item"


  events:
    'click .reply': 'showReplyForm'
    'click .up'  :  'upRate'
    'click .down':  'downRate'

  initialize: (opts)->
    {@type, @id} = opts
    @listenTo @model, 'change:likes', @render
    @formView = ''
    @childViews = []

  showReplyForm: (e)->
    e.preventDefault()
    e.stopPropagation()
    return showErrors(CommentsApp.Messages.not_authorized) unless CommentsApp.CurrentUser.get('id')
    if _.isEmpty(@formView)
      @formView = new CommentsApp.Views.ReplyFormView({@type, @id, parent_id: @model.get('id')})
      @$el.find('footer').html(@formView.el)
    else
      @formView.remove()
      @formView = ''

  # TODO переписать с применением клонирования и проверкой на стороне клиента
  upRate: (e)->
    e.preventDefault()
    e.stopPropagation()
    return showErrors(CommentsApp.Messages.not_authorized) unless CommentsApp.CurrentUser.get('id')
    @model.upRate (data)-> showNotices(data.message)

  downRate: (e)->
    e.preventDefault()
    e.stopPropagation()
    return showErrors(CommentsApp.Messages.not_authorized) unless CommentsApp.CurrentUser.get('id')
    @model.downRate (data)-> showNotices(data.message)

  # Выставляется паддинг для вложенных комментариев
  setDepthPadding: ->
    # Если depth меньше или равна CommentsApp.Config.depth, задаем паддинг
    if @model.get('depth') <= CommentsApp.Config.depth
      @el.style.paddingLeft = (@model.get('depth') * CommentsApp.Config.paddingLeft) + 'px'
    else
      # Иначе задаем паддинг максимальной глубины
      @el.style['padding-left'] = (CommentsApp.Config.paddingLeft * CommentsApp.Config.depth) + 'px'

    # Если depth равна или больше 1, то комментарий вложенный
    if @model.get('depth') >= 1
      @el.className = @el.className + ' nested'

  render: ->
    @$el.html(@template.render({model: @model.toJSON(), text: CommentsApp.ViewText}))
    @setDepthPadding()
    @
