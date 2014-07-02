$ ->
  if $('#tactical_scheme_in_detail').prop('checked')
    $('.halfback-js input').attr('disabled', true)
    $('.halfback-detail-js').removeClass('hidden')

  $('#tactical_scheme_in_detail').on 'change', (e) ->
    if this.checked
      $('.halfback-detail-js').removeClass('hidden')
      $('.halfback-js input').attr('disabled', true)
    else
      $('.halfback-detail-js').addClass('hidden')
      $('.halfback-js input').attr('disabled', false)

  $('.halfback-detail-js input').on 'change', (e) ->
    inputs = $('.halfback-detail-js input')
    halfbacks = 0
    for el in inputs
      halfbacks += parseInt($(el).val())
    $('.halfback-js input').eq(0).attr('value', halfbacks)
