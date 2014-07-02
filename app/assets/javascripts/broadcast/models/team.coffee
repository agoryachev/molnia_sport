class Broadcast.Models.Formation extends Backbone.Model
  initialize: ->
    for key, value of @attributes
      @set key, new Broadcast.Collections.Players value if _.isArray value

  find_player: (id) ->
    _.compact(value.get(id) for key, value of @attributes)[0]

  get_schema: ->
    _(players.length for key, players of @attributes when key isnt 'goalkeeper').reverse().join('-')

  toJSON: ->
    json = super
    for key, value of @attributes
      json[key] = value.toJSON()
    json


class Broadcast.Models.Team extends Backbone.Model
  initialize: ->
    formation = new Broadcast.Models.Formation @get('formation')
    @set 'formation', formation
    @set 'reserve', new Broadcast.Collections.Players @get('reserve')
    @set 'schema', formation.get_schema()

  find_player: (id) ->
    @get('formation').find_player(id)

  find_line: (type) ->
    @get('formation').get(type)

  toJSON: ->
    json = super
    json.formation = json.formation.toJSON()
    json.reserve   = json.reserve.toJSON()
    json

class Broadcast.Collections.Teams extends Backbone.Collection
  model: Broadcast.Models.Team

  toJSON: ->
    json = {}
    for model in @models
      json[model.get('side')] = model.toJSON()
    json

