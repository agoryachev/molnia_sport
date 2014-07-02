class Sport.Routes.CalendarRouter extends Backbone.Router
  routes:
    'calendars': 'init'

  init: ->
    Sport.Vent.trigger 'render:last:tour'
    Sport.Vent.trigger 'render:statistic:table'
    Sport.Vent.trigger 'render:tours'