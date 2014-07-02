$(document).scroll ()->
  if $(@).scrollTop() >= 60
    $('nav').css('position', 'fixed').css('top', 0)
    $('header .wrap').css({'padding-top': '105px'});
  else if $(this).scrollTop() <= 60
    $('header .wrap').css({'padding-top': '105px'});
    $('nav').css('position', 'absolute').css('top', 60)



$ ->
  COLORSFROMSERVER = {}
  if COLORSFROMSERVER
    $.post '/categories/get_category_colors', (colors)->
      for color in colors
        COLORSFROMSERVER[color.title] = color.color
      _.extend(COLORSFROMSERVER, {'Главная': 'red_page'})

  COLORS = {
    'Футбол': 'green_page',
    'Хоккей': 'blue_page',
    'Главная': 'red_page'
  }




  _prevActived = $('li.first-level-js').find('a.active').first()
  if (submenu = _prevActived.parents('li.first-level-js').find('.submenu-box')).length > 0
    submenu.css({height: '49px'})
  colors = COLORSFROMSERVER || COLORS;

  $('li.first-level-js').hover (e)->
    unless $(@).find('a').first().text().trim() is _prevActived.text().trim()
      _prevActived.removeClass('active')
      submenu.css({height: '0'})
      $(@).find('a').first().addClass('active')
    $(@).find('.submenu-box').css({height: 243})
    currentMenuText = $(@).find('a').first().text().trim()
    $('body').attr('id', colors[currentMenuText]);

  , ->

    $(@).find('.submenu-box').css({height: 0})
    $('li.first-level-js').find('a').removeClass('active')
    $('body').attr('id', colors[_prevActived.text().trim()]);
    _prevActived.addClass('active')
    _prevActived.parents('li.first-level-js').find('.submenu-box').css({height: '49px'})
