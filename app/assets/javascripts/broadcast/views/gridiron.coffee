'use strict'
class Broadcast.Views.Gridiron extends Backbone.View
  el: '.gridiron'
  template: HoganTemplates['broadcast/templates/gridiron']
  player_template: HoganTemplates['broadcast/templates/player']

  initialize: ->
     @listenTo Broadcast.Dispatcher, 'gridiron:render', @render

  render: ->
    @$el.empty()
    @$el.append(@template.render(teams.toJSON(), player: @player_template))
