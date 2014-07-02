# generate password for employe form
$(document).on 'click', '#generate-password', (e)->
  e.preventDefault()
  password = $.password(8)
  $('.password').val(password)
  $('.password_confirmation').val(password)
  alert('Запишите пожалуйста пароль:\n' + password)
