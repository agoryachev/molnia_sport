class Broadcast.Models.Player extends Backbone.Model
  initialize: ->
    @set 'goals', []
    @set 'cards', {}


class Broadcast.Collections.Players extends Backbone.Collection
  model: Broadcast.Models.Player