# Добавление матчей на странице редактирования тура
$(document).on 'click', '.add_matches', (event) ->
  time = new Date().getTime()
  regexp = new RegExp($(this).data('id'), 'g')
  $(this).prev('.matches').append $(this).data('fields').replace(regexp, time)
  $("select#leagues_group_matches_attributes_#{time}_team_home_id, select#leagues_group_matches_attributes_#{time}_team_guest_id").selectize
    plugins: ['remove_button']
    valueField: 'id'
    labelField: "title"
    searchField: 'title'
    create: false
    render:
      item: (item, escape)->
        return "<div>#{escape(item.title)}</div>"
      option: (item, escape)->
        return "<div>#{escape(item.title)}</div>"

    load: (query, callback)->
      if (!query.length) then return callback()
      $.ajax
        url: '/backend/teams/get_teams_for_select'
        type: 'GET',
        data: {query}
        success: (data)-> callback(data)
  window.refreshDatetimepicker()
  event.preventDefault()


$(document).on 'click', '.remove_match', (event) ->
  $(this).next('input[type=hidden]').val('1')
  $(this).parents('.match').hide()
  event.preventDefault()