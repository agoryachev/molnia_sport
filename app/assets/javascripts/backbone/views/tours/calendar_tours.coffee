class Sport.Views.CalendarTours extends Backbone.View
  el: '.tournaiments_list2'
  @mixin(Sport.Utils.SerializeCalendarFilter)

  initialize: ->
    @nestedViews = []
    @collections = []
    # @listenTo Sport.Vent, 'filter:updated', @fetchToursCollections
    @listenTo Sport.Vent, 'last:tour:id', @fetchToursCollections
    # @fetchToursCollections()

  fetchToursCollections: (last_tour_id)->
    @collections = []
    @nestedViews = []
    data = @serialize()
    data.last_tour_id = last_tour_id
    $.get '/calendars/ajax_tours', data, (tours)=>
      if _.isEmpty(tours)
        @$el.fadeOut 300, => @$el.empty()
        showNotices('Не найдно туров')
        @collections = []
      else
        for key, value of tours
          @collections.push new Sport.Collections.Tours(value)

        @renderToursCollections()

  renderToursCollections: ->
    @$el.empty()
    @collections.forEach (collection)=>
      v = new Sport.Views.CalendarTourTable({collection})
      @nestedViews.push(v)
      @$el.append(v.render().el)
    @$el.fadeIn()

    container = document.querySelector('.tournaiments_list2')
    pckry = new Packery container,
      itemSelector: '.pad'
      gutter: 10
