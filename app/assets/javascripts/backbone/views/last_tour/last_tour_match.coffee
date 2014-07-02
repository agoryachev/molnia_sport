# Backbone View которая занимается матча в последнем найденном туре на странице календаря

class Sport.Views.LastTourMatch extends Backbone.View
  template: HoganTemplates['backbone/templates/last_tour/item']

  initialize: ->
    @$el.hide()

  render: ->
    @model.attributes.match_count_guest ?= '-'
    @model.attributes.match_count_home ?= '-'

    @$el.html(@template.render(@model.toJSON()))
    @$el.fadeIn()
    @