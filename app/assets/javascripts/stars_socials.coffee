class TweeterInstagramBoxRouter extends Backbone.Router
  routes:
    '': 'runSocialBox'
    'tag/:tag': 'runSocialBox'

  runSocialBox: ->
    Sport.Vent.trigger 'run:social:box:for:main:page'

new TweeterInstagramBoxRouter

setPackery = ->
  container = document.querySelector('.news_list_wide')
  window.pckry = new Packery container,
    itemSelector: 'article'
    gutter: 20

setTwitterHeight = ->
  tweetBoxes = document.querySelectorAll('.tweet-box')
  tweets = []
  tweets.push tweet.offsetHeight for tweet in tweetBoxes

  socMenuHeight = document.querySelector('.stars-socials-menu').offsetHeight
  document.querySelector('.stars-socials').style.height = _.max(tweets) + socMenuHeight + 16 + 'px'
  setPackery()

setInstagramHeight = ->
  instagramBoxHeight = document.querySelector('.instagram-box').offsetHeight

  socMenuHeight = document.querySelector('.stars-socials-menu').offsetHeight
  document.querySelector('.stars-socials').style.height = instagramBoxHeight + socMenuHeight + 16 + 'px'
  setPackery()



# табы для твиттер и инстаграм на главной
$(document).on 'click', 'ul.stars-socials-menu li:not(.current)', ->
  $(this).addClass('current').siblings().removeClass('current')
    .parents('article.section').find('div.box').eq($(this).index()).fadeIn(0).siblings('div.box').hide()

  if $(this).text().trim() is 'Twitter'
    setTwitterHeight()
  else
    setInstagramHeight()


Sport.Vent.on 'run:social:box:for:main:page', ->
  # Подгрузка картинки в твиттер ленте
  $(document).on 'click', '.tweet-btn-show-media', ->
    $(this).addClass('hidden')
    $img = $(this).siblings('a').find('.tweet-image')
    $img.removeClass('hidden')

    setTwitterHeight()
