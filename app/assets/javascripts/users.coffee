
# Обновление аватарки
$('.edit_user').fileupload
  add: (e, data)->
    data.submit()
  # progressall: (e, data)->
  #   progress = parseInt(data.loaded / data.total * 100, 10)
  #   $('.upload').css('width', 0)
  #   $('.upload').css('width', progress)
  #   console.log progress
  success: (data)->
    $('.avatar, .users_header_menu').find('img').attr('src', data.image)
    showMessageBridge(data.errors.notice) if data.errors.notice?


emptyModalBody = ()->
  $('.modal-body').empty()

appendNewView = (view)->
  $('.modal-body').append(view)

# Модельные окна пользователя
$('.reg').on 'click', ( e )->
  e.preventDefault()
  $(@).trigger('showRegistrationView')

$('.login').on 'click', ( e )->
  e.preventDefault()
  $(@).trigger('showLoginView')

$('.reg').on 'showRegistrationView', ()->
  $.get '/templates/registrations/new', (data)=>
    emptyModalBody()
    appendNewView(data)
    $.fn.custombox(this)

$('.login').on 'showLoginView', ()->
  $.get '/templates/sessions/new', (data)=>
    emptyModalBody()
    appendNewView(data)
    $.fn.custombox(this)

$('.cabinet').on 'click', (e)->
  e.preventDefault()
  $.get '/templates/registrations/edit', (data)->
    $('.modal-body').empty()
    $('.modal-body').append(data)
  $.fn.custombox(this)


# При переходе на данный url вызываем формы входа или регистрации
if location.pathname == '/login'
  $('.login').trigger('showLoginView')
if location.pathname == '/registration'
  $('.reg').trigger('showRegistrationView')


$(document).on 'click', '.show_registration_form', (e)->
  e.preventDefault()
  $modalBody = $('.modal-body')
  $.get '/templates/registrations/new', (data)=>
    $modalBody.fadeOut 300, ()=>
      emptyModalBody()
      appendNewView(data)
      $modalBody.fadeIn(300)

$(document).on 'click', '.show_login_form', (e)->
  e.preventDefault()
  $modalBody = $('.modal-body')
  $.get '/templates/sessions/new', (data)->
    $modalBody.fadeOut 300, ()->
      emptyModalBody()
      appendNewView(data)
      $modalBody.fadeIn(300)


$(document).on 'click', '.submit_registration', (e)->
  e.preventDefault()
  form = $(@).parents('form')
  method = form.attr('method')
  action = form.attr('action')
  data = form.serialize()
  $erorrs = $('.show_errors')
  $.ajax
    url:  action
    type: form.attr('method')
    data: data
    success: (data)->
      if data.errors?
        $ul = $('<ul>');
        $li = $('<li>', { text: data.errors.text });
        $ul.append($li)
        if data.errors.errors?
          $ul = $('<ul>');
          $.each data.errors.errors, (index, error)->
            $li = $('<li>', { text: error });
            $ul.append($li)
        $erorrs.empty()
        $erorrs.append($ul).fadeIn(500)
      if data.login?
        location.href = '/'