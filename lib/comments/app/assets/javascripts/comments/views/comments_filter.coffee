class CommentsApp.Views.CommentsFilter extends Backbone.View
  el: '.comments .side_title'

  events:
    'click a': 'filterComments'


  filterComments: (e)->
    e.preventDefault()
    @unCheckAllFilter()
    @makeActiveSelectedFilter(e.target)
    CommentsApp.Vent.trigger 'filter:comments', e.target.getAttribute('data-filter')

  makeActiveSelectedFilter: (target)-> $(target).addClass('active')
  unCheckAllFilter: -> $('a').removeClass('active')