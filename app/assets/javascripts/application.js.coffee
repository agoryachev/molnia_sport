#= require jquery
#= require jquery_ujs

#= require hogan
#= require underscore
#= require backbone
#= require backbone/sport


#=require broadcast/broadcast

#= require menu_slider
#= require navigation
#= require group_slider
#= require set_image_title_alt
#= require mark_images_exclusive

#= require stars_socials


#= require jquery-fileupload/basic
#= require vendor/gallerySlider

#= require vendor/jquery.jscrollpane.min
#= require vendor/jquery.mousewheel
#= require vendor/jquery.jcarousel.min
#= require vendor/jquery.jcarousel-autoscroll.min
#= require vendor/jquery.nmdMessages
#= require vendor/jquery.prettyPhoto

#= require jquery.ui.tabs
#= require tether
#= require select

#= require vendor/jquery.custombox
#= require vendor/jquery.liMarquee
#= require vendor/packery.pkgd

#= require twitter_instagram_page

#= require_tree ./vendor/nmd

#= require photo_video
#= require clock
#= require transfers
#= require users
#= require comments
#= require top_news

#= require_self

#= require ajax_load_posts

#= require site

#=require played_matches
#=require match_live

$ ->
  # инициализирует кастомные селекты
  Select.init({selector: '#category_id, #country_id, #league_id, #year_id'})

  if location.pathname.split('/').pop() is 'calendars'
    container = document.querySelector('.tournaments-block')
    pckry = new Packery container,
      itemSelector: '.tournaments-block-left',
      gutter: 20

  pane_params =
    scrollbarWidth: 10
    # autoReinitialise: true
    # verticalDragMaxHeight:200
    # verticalDragMinHeight:15
    # verticalGutter:0

  $('.columnists-box').jScrollPane(pane_params);

  $('.js-video').each ->
    $video = $ @
    $video.nmdVideoPlayerJw
      setup: $video.data()
  # Поиск
  $("form.search_form").on "submit", (e) ->
    e.preventDefault()
    searchQuery = $.trim($(this).find("input[type=\"text\"]").val())
    window.location = "/search/" + encodeURIComponent(searchQuery)  if searchQuery

setDateTime('.time_val', 1000)

if $('.errors').length > 0
  hideMessage = ->
    $('.errors').remove()
  setTimeout(hideMessage, 2000)

# Ajax загрузака контента при клике на кнопку еще
$('.pagination').hide() if $('.pagination .next_page')

$(document).on 'click', '.more', (e) ->
  e.preventDefault()

  url = $('.pagination .next_page').attr('href')
  $.getScript(url)





$(document).on 'click', '.dropdown', (e)->
  e.preventDefault()
  $(@).find('.js-link').toggleClass('open')
  $(@).find('.js-link').toggleClass('closed')
  $(@).find('.submenu').fadeToggle(100)
  if $(@).parent('.current-social-icon').height() is 61
    $(@).parent('.current-social-icon').css('height', 38)
  else
    $(@).parent('.current-social-icon').css('height', 61)
