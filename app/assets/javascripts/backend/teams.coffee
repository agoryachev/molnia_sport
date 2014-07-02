if 'teams' in location.href.split('/')
  category_id = $('#team_category_id').val()
  $country_select = $('#team_country_id')
  teamId = $country_select.parents('.form-group').data('teamId')
  $.post '/backend/countries/get_countries_for_ajax', {category_id}, (data)->
    $country_select.empty()
    _.each data, (country)->
      if teamId is country.id
        $option = $("<option value='#{country.id}' selected >#{country.title}</option>")
      else
        $option = $("<option value='#{country.id}'>#{country.title}</option>")
      $country_select.append $option

$(document).on 'change', '#team_category_id', (e)->
  $country_select = $('#team_country_id')
  category_id = $(@).val()
  $.post '/backend/countries/get_countries_for_ajax', {category_id}, (data)->
    $country_select.empty()
    _.each data, (country)->
      $country_select.append $("<option value='#{country.id}'>#{country.title}</option>")