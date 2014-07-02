class Sport.Models.LastTourMatch extends Backbone.Model

class Sport.Collections.LastTourMatches extends Backbone.Collection
  model: Sport.Models.LastTourMatch
  url: '/calendars/ajax_last_tour'

  parse: (res)->
    @last_tour = res.last_leagues_group
    res.matches