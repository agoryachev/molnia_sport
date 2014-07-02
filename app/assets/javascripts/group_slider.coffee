class Slider
  current: 0
  commonWidth: 0
  shown: 1

  constructor: (opts)->
    {itemsSelector, wrapperSelector, listSelector, @shown, controls, @offset, @el} = opts
    @el = document.querySelector(@el)
    return unless @el?
    @current = opts.current if opts.current
    @setList(listSelector)
    @setItems(itemsSelector)
    @setItemsCount()
    @setCommonWidth()
    @setListWidth()
    @setWrapper(wrapperSelector)
    @setWrapperWidth()
    @setCurrentMax()
    @setControlsListeners(controls)
    @setCurrentStyles()

  setList: (listSelector)->
    @list = @el.querySelector(listSelector)
  setItems: (itemsSelector)->
    @items = @el.querySelectorAll(itemsSelector)
  setItemsCount: ->
    @itemsCount = @items.length
  setCommonWidth: ->
    @commonWidth += item.offsetWidth + 20 for item in @items

  setListWidth: ->
    @list.style.width = "#{@commonWidth}px"
  setWrapper: (wrapper)->
    @wrapper = @el.querySelector(wrapper)
  setWrapperWidth: ->
    @wrapperWidth = @wrapper.offsetWidth

  setCurrentMax: ->
    # @currentMax = ~~(@itemsCount / @shown).toString()[0]
    @currentMax = Math.ceil(@itemsCount / @shown)

  setControlsListeners: (controls)->
    @groupOf = document.querySelectorAll('.leagues-groups-title-group-of')
    for selector in @groupOf
      selector.addEventListener 'click', (e)=>
        e.preventDefault()
        @groupOfClick(e)

    for selector in @el.querySelectorAll("#{controls} a")
      selector.addEventListener 'click', (e)=>
        e.preventDefault()
        @[e.target.getAttribute('data-dir')]()

  setCurrentStyles: ->
    $('.leagues-groups-title-group-of').eq(0).addClass('selected-groups')

  groupOfClick: (e)=>
    if @groupOf[0] is e.target then @prev() else @next()
    $target = $(e.target)
    $('.leagues-groups-title-group-of').removeClass('selected-groups')
    if $target.hasClass('leagues-groups-title-group-of')
      $target.addClass('selected-groups')
    else
      $target.parent().addClass('selected-groups')

  next: ->
    @current += 1
    @scroll('next')

  prev: ->
    return if @current is 0
    @current -= 1
    @scroll('prev')

  scroll: (direction)->
    selectedLine = document.querySelector('.selected-line')
    if (@current + 1) <= @currentMax
      @unit = if direction is 'next' then '-' else '+'
      if @current is 0
        @list.style.left = "0px"
        selectedLine.style.left = "0px"
        return 
      if @current isnt 0 and @unit is '-'
        @list.style.left = "#{@unit+(@offset*@current)}px"
        if @unit is '+'
          selectedLine.style.left = "-#{(129*@current)}px"
        else
          selectedLine.style.left = "+#{(129*@current)}px"
      if @current > 0 and @unit is '+'
        @list.style.left = "-#{(@offset*@current)}px"
        selectedLine.style.left = "-#{(129*@current)}px"
    else
      @list.style.left = "0px";
      selectedLine.style.left = "0px"
      @current = 0

new Slider
  el: 'section.group-slider'
  listSelector: '.list'
  itemsSelector: '.list li'
  wrapperSelector: '.list-wrapper'
  shown: 4
  controls: '.controls'
  offset: 904