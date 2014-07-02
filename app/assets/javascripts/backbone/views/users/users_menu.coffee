class Sport.Views.UsersMenu extends Backbone.View
  el: '.hd_links'

  events:
    'click .users_header_menu': 'toggleNestedMenu'

  initialize: ->
    @$menuLink = @el.querySelector('.user_show_menu_link')
    @$nestedMenu = document.querySelector('.user_nested_header_menu')
    @userHeaderMenu = document.querySelector('.users_header_menu')
    @userHeaderMenu.style.height = '35px'

  toggleNestedMenu: (e)->
    e.preventDefault()
    if @$nestedMenu.clientHeight is 0
      @showNestedMenu()
    else
      @hideNestedMenu()

  showNestedMenu: ->
    @$nestedMenu.style.minWidth = "#{@userHeaderMenu.offsetWidth}px"
    @$nestedMenu.style.height = '145px'
    @userHeaderMenu.style.height = '200px'

    @removeClass(@$menuLink, 'up_arrow')
    @addClass(@$menuLink, 'down_arrow')
    @addClass(@$menuLink, 'active')

    @$nestedMenu.style.display = 'block'

  hideNestedMenu: ->
    @removeClass(@$menuLink, 'down_arrow')
    @removeClass(@$menuLink, 'active')
    @userHeaderMenu.style.height = '35px'
    @addClass(@$menuLink, 'up_arrow')
    
    @$nestedMenu.style.display = 'none'

  addClass: (target, className)->
    return if target?.classList?.add(className)
    target.className += ' ' + className;

  removeClass: (target, className)->
    return if target.classList?.remove(className)
    target.className.replace(new RegExp(className), '')

# Запускаем если пользователь авторизировани и есть вложенное меню
if document.querySelector('.user_nested_header_menu')?
  new Sport.Views.UsersMenu