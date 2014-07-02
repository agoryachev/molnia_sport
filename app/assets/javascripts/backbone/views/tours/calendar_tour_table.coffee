class Sport.Views.CalendarTourTable extends Backbone.View
  className: 'pad'
  tagName: 'div'
  template: HoganTemplates['backbone/templates/tours/tour_table']

  initialize: ->
    @nestedViews = []
    @$el.hide()

  renderCollection: ->

    @collection.forEach (model)=>
      v = new Sport.Views.CalendarTourItem({model})
      @nestedViews.push(v)
      @$el.find('tbody').append(v.render().el)
    @$el.fadeIn()

  render: ->
    @$el.html(@template.render({title: @collection.first().get('leagues_group_title')}))
    @renderCollection()
    @