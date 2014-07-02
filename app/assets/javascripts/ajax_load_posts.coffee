# xhr загрузка постов по колонкам
ajaxLoadFeed = ->
  addStarsInSocialNetworks = (data, offset)->

    if $("section.news_list_wide article")[1]
      $(data).insertBefore($("section.news_list_wide article").eq(1))
    else if $("section.news_list_wide article")[0]
      $(data).insertBefore($("section.news_list_wide article").eq(0))
    else
      $("section.news_list_wide").append(data)
  lc = $('section.lc').eq(0)
  url = lc.data('url')

  if url?
    contentBlockHeight = 300
    rcHeight = 0
    lcOffset = 0
    lcChildrens = lc.children()
    articles_count = 0

    for val in $('aside.rc').eq(0).children()
      if $(val).html()
        rcHeight += $(val).outerHeight(true)
    for elem in lcChildrens
      el = $(elem)
      break if el.hasClass('news_list')
      lcOffset += el.outerHeight(true)
    articles_count = Math.round(((rcHeight - lcOffset) / contentBlockHeight) + 1)
    $.ajax
      type: 'GET'
      url: location.pathname
      data:
        count: if (articles_count > 0) then (2 * articles_count) else 0

      success: (response)->
        top_feed = $("section.lc section.news_list")
        lc.find('section.news_list').empty()
        for val in response.top_box
          $(val).appendTo(top_feed)

        if top_feed.children().length is 0
          top_feed.addClass('hidden')

        for val in response.bottom_box
          $(val).appendTo("section.news_list_wide")
        startNetworksOffset = if (response.bottom_box.length > 6) then 6 else response.bottom_box.length
        addStarsInSocialNetworks(response.stars, startNetworksOffset)
        container = document.querySelector('.news_list_wide')
        window.pckry = new Packery container,
          itemSelector: 'article'
          gutter: 20
        $( "#stars-socials-tabs" ).tabs()


# if location.pathname.split('/')[1] is 'post_status'
#   ajaxLoadFeed()
