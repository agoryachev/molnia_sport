$ ->
  $('#categories').sortable
    axis: 'y'
    handle: '.handle'
    update: ->
      $.post $(this).data('update-url'), $(this).sortable('serialize')

  $(document).on 'ajax:success', 'form.category_publish', (s, data, x)->
    $(s.target).parents('li').toggleClass('muted').find('a').toggleClass('muted')