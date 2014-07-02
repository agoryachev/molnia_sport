# Backbone View которая занимается отрисовкой посленднего
# тура по выбранным параметрам года и лиги в фильтре на странице календаря

class Sport.Views.LastTour extends Backbone.View
  el: '.match_list'
  @mixin(Sport.Utils.SerializeCalendarFilter)

  initialize: ->
    @nestedViews = []
    @$el.hide()
    @listenTo Sport.Vent, 'filter:updated', @fetchCollection
    @fetchCollection()

  fetchCollection: ->
    @collection = new Sport.Collections.LastTourMatches
    data = @serialize()
    @collection.fetch
      data: data
    .done (data)=>
      if data.error
        Sport.Vent.trigger "last:tour:id", null
        @$el.fadeOut 300, => @$el.empty()
      else
        @render()
        @setLastTrourTitle()

  render: ->
    console.log @collection
    Sport.Vent.trigger "last:tour:id", @collection.last_tour.id
    @$el.empty()
    @collection.forEach (model)=>
      v = new Sport.Views.LastTourMatch({model})
      @nestedViews.push v
      @$el.append(v.render().el)
    @$el.fadeIn()
    @

  setLastTrourTitle: ->
    @$el.prepend("<h3>#{@collection.last_tour.title}</h3>")
