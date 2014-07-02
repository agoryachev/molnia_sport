class Sport.Views.LeaguesStatisticsTable extends Backbone.View
  el: '.tournaiments_list'
  template: HoganTemplates['backbone/templates/leagues_statistics/table']
  @mixin(Sport.Utils.SerializeCalendarFilter)

  initialize: ->
    @nestedViews = []
    @$el.hide()
    @listenTo Sport.Vent, 'filter:updated', @fetchCollection
    @fetchCollection()

  fetchCollection: ->
    @collection = new Sport.Collections.LeaguesStatistics
    data = @serialize()
    @collection.fetch
      data: data
    .done (data)=>
      if _.isEmpty(data.statistics)
        @$el.fadeOut 300, => @$el.empty()
      else
        @renderCollection()
        @setLeagueTitle()

  renderCollection: ->
    @render()
    @collection.forEach (model, index)=>
      model.set({index: index+1})
      v = new Sport.Views.LeaguesStatisticsItem({model})
      @nestedViews.push v
      @$el.find('tbody').append(v.render().el)
      @$el.fadeIn()

  setLeagueTitle: ->
    @$el.find('h3').text(@collection.league_title)

  render: ->
    @$el.html(@template.render())