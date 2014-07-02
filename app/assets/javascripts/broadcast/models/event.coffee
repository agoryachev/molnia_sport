class Broadcast.Models.Event extends Backbone.Model

class Broadcast.Collections.Events extends Backbone.Collection
  model: Broadcast.Models.Event

  comparator: (model) ->
    model.get('message').time

  url: ->  "/matches/#{@id}"

  parse: (resp)->
    @models = resp.messages