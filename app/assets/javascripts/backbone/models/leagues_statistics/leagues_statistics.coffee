class Sport.Models.LeaguesStatistics extends Backbone.Model


class Sport.Collections.LeaguesStatistics extends Backbone.Collection
  model: Sport.Models.LeaguesStatistics
  url: 'calendars/ajax_leagues_statistics'

  parse: (data)->
    @league_title = data.league_title
    data.statistics