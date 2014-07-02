# При сохранении каммента
$(document).on 'ajax:success', '#new_comment', (s, data, x) ->
  if typeof data is 'object'
    unless data.errors?
      showNotices data.msgs
      $('#comment_content').val ''
    else
      showErrors data.errors
  else
    $data = $(data)
    $('.comnts_list article').remove()
    $list = $('.comnts_list')
    if(!$list.length)
      $('.comnts_pad').append $('<section class="comnts_list"/>')
    $('.comnts_list').append $data
    showNotices 'Комментарий успешно добавлен'
    $('#comment_content').val ''

# При голосовании за каммент
$('.up_rate, .down_rate').on 'ajax:success', (s, data, x) ->
  $div = $(this).closest 'div'
  $rating = $('.rate_val', $div)
  rating = parseInt $rating.html()
  $(this).hide()
  if $(this).hasClass 'up_rate'
    $rating.html(++rating)
  else
    $rating.html(--rating)
  $('a', $div).remove()
  showNotices 'Ваш голос учтен!'