_.templateSettings =
  interpolate: /\{\{(.+?)\}\}/g

$(document).on 'click', '.top_news_links a', (e)->
  e.preventDefault()
  $('.tags_list').find('li').removeClass('active')
  $list = $('.top_news_links').next()
  $(@).parents('li').addClass('active')
  $.get $(@).attr('href'), (data)->
    unless _.isEmpty(_.compact(data))
      $list.empty()
  #     template = _.template($('#top-post-template').html())
  #     _.each data, (data)->
  #       $list.append(template(data))