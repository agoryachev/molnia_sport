class Broadcast.Models.Match extends Backbone.Model
  urlRoot: '/matches'

  update_score: (goal_event) ->
    @events.push(goal_event)
    @set events: @events
    @score[goal_event.team_id] += 1
    @set score: @score

  parse: (response) ->
    console.log response.messages
    @set('events', new Broadcast.Collections.Events(response.messages))
    response
    # events
    # messages
