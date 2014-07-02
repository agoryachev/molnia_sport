class Sport.Views.PhotoVideoView extends Backbone.View
  el: 'section.big_slider_wr'

  events:
    'click a.lbtn': 'left'
    'click a.rbtn': 'right'
    'click div.slide': 'select'

  count: 16

  initialize: ->
    slide = $('.slide.slide_1')
    $('.slide.slide_1').find("img").first().wrap("<a href='/categories/#{slide.data('category')}/#{slide.data('type')}/#{slide.data('id')}'></a>")

  left: (e) ->
    e.preventDefault()
    @setFirst @second()

  right: (e) ->
    e.preventDefault()
    @setFirst @last()

  select: (e) ->
    $selected = $(e.target).closest('div.slide')
    @setFirst $selected

  setFirst: ($selected) ->
    $slides = @$('div.slide')

    if @$('div.slide').find("img").first().parent().is('a')
      @$('div.slide').find("img").first().unwrap()

    @clearNumbers $slides

    i = 0
    $slides.each (index, slide) =>
      $slide = $(slide)
      if i > 0
        i += 1
        @setNumber $slide, i
      if $slide.get(0) is $selected.get(0)
        i = 1
        @setNumber $slide, i

    $slides.each (index, slide) =>
      $slide = $(slide)
      unless $slide.data('number') is 1
        i += 1
        @setNumber $slide, i
      else false
    slide = $('.slide.slide_1')
    $('.slide.slide_1').find("img").first().wrap("<a href='/categories/#{slide.data('category')}/#{slide.data('type')}/#{slide.data('id')}'></a>")

  clearNumbers: ($slides) ->
    $slides.attr 'class', 'slide'

  setNumber: ($slide, number) ->
    $slide.addClass "slide_#{number}"

  second: ->
    @$('div.slide_2')

  last: ->
    @$("div.slide_#{@count}")