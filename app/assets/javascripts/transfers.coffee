_.templateSettings =
  interpolate: /\{\{(.+?)\}\}/g

$(document).on 'change', '.transfer.search_form #category_id', (e)->
  categoryId = $(@).val()
  location.href = "/transfers/categories/#{categoryId}"

$(document).on 'change', '#country_id', (e)->
  countryId = $(@).val()
  categoryId = $('#category_id').parents('.fl').find('.selectBox-label').attr('rel')
  $.post '/transfers/filter_clubs', {countryId, categoryId}, (clubs)-> show_posts(clubs)

show_posts = (clubs)->
  $('.clubs_list').empty()
  template = _.template($('#club-template').html())
  _.each clubs, (club)->
    $('.clubs_list').append(template(club))