#= require vendor/jwplayer/jwplayer
#= require vendor/jwplayer/jwplayer.html5
#= require vendor/jwplayer/jwplayer.key

$ ->
  methods =
    init: (options) ->
      settings = $.extend true,
        setup:
          primary: 'flash'
          flashplayer: '/video_player/jwplayer.flash.swf'
          skin: '/video_player/skins/stormtrooper.xml'
          width: '100%'
          height: '100%'
          startparam: 'start'
          aspectratio: '16:9'
        onInit: $.noop
      , options
      
      @each ->
        $player = $(@)
        
        playerId = $player.attr 'id'
        unless playerId
          playerId = Math.random().toString(36).substring(7);
          $player.attr 'id', playerId

        jwplayer(playerId).setup settings.setup
        settings.onInit.apply @

    pause: ->
      @each ->
        $player = $(@)
        playerId = $player.attr 'id'
        jwplayer(playerId).pause true

    stop: ->
      @each ->
        $player = $(@)
        playerId = $player.attr 'id'
        jwplayer(playerId).stop()

    play: ->
      @each ->
        $player = $(@)
        playerId = $player.attr 'id'
        jwplayer(playerId).play true

  $.fn.nmdVideoPlayerJw = (method) ->
    if methods[method]
      methods[method].apply @, Array::slice.call(arguments, 1)
    else if typeof method is "object" or not method
      methods.init.apply @, arguments
    else
      $.error "Метод с именем #{method} не существует для jQuery.nmdVideoPlayerJw"