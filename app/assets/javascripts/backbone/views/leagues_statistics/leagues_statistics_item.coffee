class Sport.Views.LeaguesStatisticsItem extends Backbone.View
  tagName: 'tr'
  template: HoganTemplates['backbone/templates/leagues_statistics/item']

  initialize: ->
    @$el.hide()

  render: ->
    @$el.html(@template.render(@model.toJSON()))
    @$el.fadeIn()
    @