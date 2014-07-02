$('.comment-body-js').hide()
$(document).on 'click', '.comment-title-link-js', (e)->
  e.preventDefault()
  $(this).parents('tr').find('.comment-body-js').toggle()