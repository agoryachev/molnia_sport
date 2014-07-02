class BroadcastMessages.Routes.MainRoute extends Backbone.Router
  routes:
    'backend/matches/:id': 'initMessages'
    'backend/matches/:id/': 'initMessages'

  initMessages: (id)->
    new BroadcastMessages.Views.Form