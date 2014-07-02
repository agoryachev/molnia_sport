class Sport.Routes.ApplicationRouter extends Backbone.Router
  routes:
    'photo_video*params': 'photoVideo'
    'categories/:category_id/:type/:id': 'showNestedComments'
    ':pages/:id': 'showComments'

  photoVideo: (params) ->
    # TODO: раскрыть все возможные параметры
    new Sport.Views.PhotoVideoView

  # Метод устанавливает триггеры, которые срабатывают при просмотре новости
  postShowTriggers: ->
    # запускает обработчик вывода title и alt для изображений новости
    Sport.Vent.trigger('set:image:title:alt')
    # запускает обработчик расстановки на изображения метки "Эксклюзивно"
    Sport.Vent.trigger('mark:images:exclusive')


  showNestedComments: (category_id=null, type, id)->
    CommentsApp.Vent.trigger 'show:comments', type, id, category_id
    if type is 'posts'
      @postShowTriggers()

  showComments: (type, id)->
    CommentsApp.Vent.trigger 'show:comments', type, id
    if type is 'matches'
      Broadcast.Dispatcher.trigger 'fetch:events', id