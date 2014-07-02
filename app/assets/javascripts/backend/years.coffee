$(document).on 'click', '.open-modal', (e)->
  e.preventDefault()
  $('.modal-body').find('.modal-alert').detach()
  $('.modal-body').find('input[type="text"]').val('')
  action = $('.modal-body').find('form').attr('action')
  action = action.replace(/\/\d+\/update_year_from_modal/, '')
  $('.modal-body').find('form').attr('action', action)
  $('.modal-body').find('form').attr('method', 'POST')
  $($(@).data('target')).modal('show')

$alert = $('<div class="modal-alert alert", style="display: none;"></div>')
$(document).on 'click', '.modal-body input[name="commit"]', (e)->
  e.preventDefault()
  form = $(@).parents('form')
  method = form.attr('method')
  action = form.attr('action')
  data = form.serialize()
  $.ajax
    url:  action
    type: form.attr('method')
    data: data
    success: (data)->
      if data.notices?
        $alert.empty()
        $('.modal-body').prepend($alert.removeClass('alert-danger').addClass('alert-success').append(data.notices.text).fadeIn(500))
        if /\d+/.test(action)
          action = action.replace(/\d+/, data.notices.id)
        else
          action = "#{action}/#{data.notices.id}"
        method = 'PUT'
        $.post "/backend/leagues/#{$('#year_league_id').val()}/#{data.notices.id}/update_years/"
      if data.errors?
        if data.errors.errors?
          $ul = $('<ul>');
          $.each data.errors.errors, (index, error)->
            $li = $('<li>', { text: error });
            $ul.append($li)
        $alert.empty()
        $('.modal-body').prepend($alert.addClass('alert-danger').append(data.errors.text).append($ul).fadeIn(500))
      form.attr('action', action)
      form.attr('method', method)