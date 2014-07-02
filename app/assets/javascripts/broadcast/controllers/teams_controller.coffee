class Broadcast.Controllers.TeamsController
  constructor: ->
    _.extend @, Backbone.Events
    @listenTo Broadcast.Dispatcher, 'fetch:done', @init, @

  init: ->
    @listenTo events, 'add', @addOne
    new Broadcast.Views.Gridiron
    new Broadcast.Views.Reserve
    events.forEach @handle, @
    @emmit(true)

  addOne: (model) ->
    @handle(model)
    @emmit(model.get('event')?.replacement?)

  handle: (message) ->
    event = message.get('event')
    if event?
      team = teams.get(event.team.id)
      switch
        when event.goal?
          player = team.find_player(event.player.id)
          player.get('goals').push event.image if player?
        when event.replacement?
          player_out = team.find_player(event.player_out.id)
          if player_out?
            reserve   = team.get('reserve')
            line      = team.find_line(player_out.get('type'))
            player_in = reserve.get(event.player_in.id)
            if player_in?
              player_in.set('type', player_out.type)
              line.remove    player_out
              line.add       player_in
              reserve.add    player_out
              reserve.remove player_in
        when event.card?
          player = team.find_player(event.player.id)
          if player?
            if event.card_type is 'yellow' and !player.get('cards').red?
              if player.get('cards').yellow
                player.get('cards').yellow = false
                player.get('cards').red = true
              else
                player.get('cards').yellow = true
            else
              player.get('cards').yellow = false
              player.get('cards').red = true

  emmit: (touch_reserve = false) ->
    Broadcast.Dispatcher.trigger 'reserve:render' if touch_reserve
    Broadcast.Dispatcher.trigger 'gridiron:render'
