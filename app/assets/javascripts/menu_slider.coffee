class Slider
  current: 0
  commonWidth: 0
  shown: 1

  constructor: (opts)->
    {itemsSelector, wrapperSelector, listSelector, @shown, controls, @el} = opts
    @el = document.querySelector(@el)
    @current = opts.current if opts.current
    @setWrapper(wrapperSelector)
    @setWrapperWidth()
    @setList(listSelector)
    @setItems(itemsSelector)
    @setItemsCount()
    @setCommonWidth()
    @setListWidth()
    @setCurrentMax()
    @setControlsListeners(controls)

  setList: (listSelector)->
    @list = @el.querySelector(listSelector)
  setItems:  (itemsSelector)->
    @items = @wrapper.querySelectorAll(itemsSelector)
  setItemsCount:  ->
    @itemsCount = @items.length
  setCommonWidth: ->
    @commonWidth += item.offsetWidth for item in @items
  setListWidth: ->
    @list.style.width = "#{@commonWidth}px"
  setWrapper: (wrapper)->
    @wrapper = @el.querySelector(wrapper)
  setWrapperWidth: ->
    @wrapperWidth = @wrapper.offsetWidth
  setCurrentMax: ->
    @currentMax = ~~(@itemsCount / @shown).toString()[0]
  setControlsListeners: (controls)->
    for selector in @el.querySelectorAll("#{controls} a")
      selector.addEventListener 'click', (e)=>
        e.preventDefault()
        @[e.target.getAttribute('data-dir')]()

  next: ->
    @current += 1
    @scroll('next')

  prev: ->
    return if @current is 0
    @current -= 1
    @scroll('prev')

  scroll: (direction)->
    return if @currentMax is 1
    if @current <= @currentMax
      @unit = if direction is 'next' then '-' else '+'
      return @list.style.left = "0px" if @current is 0
      if @current isnt 0 and @unit is '-'
        @list.style.left = "#{@unit+(@wrapperWidth*@current)}px"
      if @current > 0 and @unit is '+'
        @list.style.left = "-#{(@wrapperWidth*@current)}px"
    else
      @list.style.left = "0px";
      @current = 0

# new Slider
#   el: 'section.menu-slider'
#   listSelector: '.list'
#   itemsSelector: '.list li'
#   wrapperSelector: '.list-wrapper'
#   shown: 6
#   controls: '.controls'
