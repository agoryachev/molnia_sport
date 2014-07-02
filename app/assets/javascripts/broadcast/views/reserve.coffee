'use strict'
class Broadcast.Views.Reserve extends Backbone.View
  el: '.reserve'
  template: HoganTemplates['broadcast/templates/reserve']
  player_template: HoganTemplates['broadcast/templates/reserve_player']

  initialize: ->
     @listenTo Broadcast.Dispatcher, 'reserve:render', @render

  render: ->
    @$el.empty()
    @$el.append(@template.render(teams.toJSON(), reserve_player: @player_template))
