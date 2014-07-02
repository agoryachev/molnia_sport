class Sport.Views.CalendarFilter extends Backbone.View
  el: '.calendar-filter'

  events:
    'change #league_id': 'fillYears'
    'change #year_id'  : 'triggerChangeYear'

  fillYears: (e)->
    $.post '/calendars/seasons', {id: e.target.value}, (years)=>
      $('#year_id').empty()
      for year in years
        if year.league_year?
          option = $("<option value='#{year.id}'>#{year.league_year} #{year.title}</option>")
        else
          option = $("<option value='#{year.id}'>#{year.title}</option>")
        $('#year_id').append(option)
      @triggerChangeLeaguesGroup()

  triggerChangeLeaguesGroup: (e)->
    Sport.Vent.trigger 'filter:updated'

  triggerChangeYear: ->
    Sport.Vent.trigger 'filter:updated'