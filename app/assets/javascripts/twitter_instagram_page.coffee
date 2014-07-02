class TweeterInstagramPageRouter extends Backbone.Router
  routes:
    'twitter_records': 'runPackeryForTwitterPage'
    'instagram_records': 'runPackeryForInstagramPage'

  runPackeryForTwitterPage: ->
    container = document.querySelector('.tweet-page-container')
    @packery(container, '.tweet-box')
    @listenClickOnImage()

  runPackeryForInstagramPage: ->
    container = document.querySelector('.instagram-page-container')
    @packery(container, '.instagram-box')

  listenClickOnImage: ->
    self = @
    $(document).on 'click', '.tweet-btn-show-media', ->
      $(this).addClass('hidden')
      $img = $(this).siblings('a').find('.tweet-image')
      $img.removeClass('hidden')
      container = document.querySelector('.tweet-page-container')
      self.packery(container, '.tweet-box')

  packery: (container, selector)->
    window.pckry = new Packery container,
      itemSelector: selector
      gutter: 0

new TweeterInstagramPageRouter
