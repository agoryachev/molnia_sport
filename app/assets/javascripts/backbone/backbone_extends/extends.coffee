mixin = (destination) ->
  _.extend this, destination.class_methods
  _.extend this.prototype, destination.instance_methods



_.extend Backbone.View, {
  mixin: mixin
}

_.extend Backbone.View::, {
  # nestedViews: []
  leave: ->
    @remove()
    @off()
    if @nestedViews.length > 0
      @nestedViews.forEach (v) -> v.leave()
}