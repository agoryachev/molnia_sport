class Sport.Views.CalendarTourItem extends Backbone.View
  tagName: 'tr'
  template: HoganTemplates['backbone/templates/tours/tour_item']

  render: ->
    @model.attributes.match_count_guest ?= '-'
    @model.attributes.match_count_home ?= '-'
    @$el.html(@template.render(@model.toJSON()))
    @