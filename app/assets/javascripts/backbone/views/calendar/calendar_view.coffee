class Sport.Views.CalendarView extends Backbone.View

  initialize: ->
    new Sport.Views.CalendarFilter
    @listenTo Sport.Vent, 'render:statistic:table', @renderStatisticTable
    @listenTo Sport.Vent, 'render:last:tour',       @renderLastTour
    @listenTo Sport.Vent, 'render:tours',           @renderTours

  renderLastTour: ->
    new Sport.Views.LastTour

  renderStatisticTable: ->
    new Sport.Views.LeaguesStatisticsTable

  renderTours: ->
    new Sport.Views.CalendarTours

new Sport.Views.CalendarView