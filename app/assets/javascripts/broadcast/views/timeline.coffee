class Broadcast.Views.TimeLine extends Backbone.View
  el: '.timeline'
  template: _.template("<div class='event' style='left: <%= Number(event.timestamp) * 10 + 23 %>px'><img title='<%= event.alt %>' src='<%= event.image %>'></div>")
  whistle: '<div class="event" style="left: 923px;"><img alt="Свисток" src="/assets/matches/svist.png"></div>'

  initialize: ->
    @listenTo @collection, 'add',    @addOne
    @listenTo @collection, 'remove', @removeOne
    @render()

  addOne: (model)->
    if model.get('event')?
      @$el.find(".comanda[data-team-id=#{model.get('event').team.id}]").find('.events').append(@template(model.toJSON()))
      $('.schet').find('.sub-text').html("#{model.get('event').timestamp}'")

  removeOne: (model) ->
    @render()

  render: ->
    @$el.find('.events').empty()
    @collection.forEach @addOne, @
    @$el.find('.comanda.two').find('.events').append @whistle