$(window).on "message", (e) ->
  data = e.originalEvent.data
  leagueId = $('.new-leagues-group').data('leagueId')

  if data? and data.model?and data.model.leagues_groups?
    $.post "/backend/years/#{data.model.year_id}/#{data.model.league_id}/update_groups/"


$('.new-leagues-group').on 'click', (e)->
  e.preventDefault()
  href = $(@).attr('href')
  myWindow = window.open(href,"_blank","width=412,height=500")

  myWindow.onload  = ()=>
    model_id = $(@).data('leagueId')
    if $(@).data('yearId')?
      yearId = $(@).data('yearId')
      myWindow.init({model_id, yearId})
    else
      myWindow.init({model_id})
  myWindow.focus()

# $(document).on 'click', '.edit-year, .edit-group', (e)->
#   e.preventDefault()
#   href = $(@).attr('href')
#   myWindow = window.open(href,"_blank","width=412,height=500")

$('#league_country_id, #team_country_id').selectize()
colors =
  'Футбол': 'green_page'
  'Хоккей': 'blue_page'

colors_name =
  'Зеленый': 'green_page'
  'Красный': 'red_page'
  'Синий': 'blue_page'

$('#category_color, #league_category_id, #team_category_id, #gallery_category_id, #video_category_id').selectize()

# $('#league_category_id, #team_category_id, #post_category_id, #gallery_category_id, #video_category_id').selectize
#   valueField: 'id'
#   labelField: "title"
#   render:
#     option: (item, escape)->
#       return "<div>#{escape(item.title)}</div>"


$('#country_category_ids').selectize
  plugins: ['remove_button']
  valueField: 'id'
  labelField: "title"
  render:
    item: (item, escape)->
      return "<div class='#{colors[$.trim(item.title)]}'>#{escape(item.title)}</div>"
    option: (item, escape)->
      return "<div class='#{colors[$.trim(item.title)]}'>#{escape(item.title)}</div>"

# Кастомные выпадающие ссылки для команд с ajax поиском на страницу групп при добавлении матча
$('.selectize-team').selectize
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

# Кастомные выпадающие ссылки для судей с ajax поиском на страницу групп при добавлении матча
$('.selectize-referee').selectize
  plugins: ['remove_button']
  valueField: 'id'
  labelField: ['name_first', 'name_last']
  searchField: ['name_first', 'name_last', 'name_v']
  create: false
  render:
    item: (item, escape)->
      if item.name_last?
        return "<div>#{escape(item.name_first)} #{escape(item.name_last)}</div>"
      else
        return "<div>#{escape(item['name_first,name_last'])}</div>"
    option: (item, escape)->
      if item.name_last?
        return "<p>#{escape(item.name_first)} #{escape(item.name_last)}</p>"
      else
        return "<div>#{escape(item.name_first)}</div>"

  load: (query, callback)->
    if (!query.length) then return callback()
    $.ajax
      url: '/backend/persons/get_referees_for_select'
      type: 'GET',
      data: {query}
      success: (data)->
        console.log(data)
        callback(data)

_.templateSettings =
  interpolate: /\{\{(.+?)\}\}/g


eventHandler = (name)->
  return ()->
    unless _.isNaN(+arguments[0])
      $.get '/backend/persons/get_persons_for_select', {id: arguments[0]}, (data)->
        template = _.template($('#person-template').html());
        $(".persons .row").append(template(data))



# Ajax загрузка игроков для трансфера
$('.persons-selectize').selectize
  plugins: ['remove_button']

$('#transfer_person_id').selectize
  plugins: ['remove_button']
  valueField: 'id'
  labelField: ['name_first', 'name_last']
  searchField: ['name_first', 'name_last', 'name_v']
  create: false

  render:
    item: (item, escape)->
      if item.name_last?
        return "<div>#{escape(item.name_first)} #{escape(item.name_last)}</div>"
      else
        return "<div>#{escape(item['name_first,name_last'])}</div>"
    option: (item, escape)->
      if item.name_last?
        return "<p>#{escape(item.name_first)} #{escape(item.name_last)}</p>"
      else
        return "<div>#{escape(item.name_first)}</div>"

  load: (query, callback)->
    if (!query.length) then return callback()
    $.ajax
      url: '/backend/persons/get_persons_for_select'
      type: 'GET'
      data: {query}
      success: (data)-> callback(data)

$('.teams-selectize, #transfer_team_from_id, #transfer_team_to_id, #match_team_home_id, #match_team_guest_id').selectize
  plugins: ['remove_button']
  valueField: 'id'
  labelField: 'title'
  searchField: 'title'
  create: false

  load: (query, callback)->
    if (!query.length) then return callback()
    $.ajax
      url: '/backend/teams/get_teams_for_select'
      type: 'GET'
      data: {query}
      success: (data)-> callback(data)

$('.referee-selectize, #match_referee_id').selectize
  plugins: ['remove_button']
  valueField: 'id'
  labelField: ['name_first', 'name_last']
  searchField: ['name_first', 'name_last', 'name_v']
  create: false
  render:
    item: (item, escape)->
      if item.name_last?
        return "<div>#{escape(item.name_first)} #{escape(item.name_last)}</div>"
      else
        return "<div>#{escape(item['name_first,name_last'])}</div>"
    option: (item, escape)->
      if item.name_last?
        return "<p>#{escape(item.name_first)} #{escape(item.name_last)}</p>"
      else
        return "<div>#{escape(item.name_first)}</div>"

  load: (query, callback)->
    if (!query.length) then return callback()
    $.ajax
      url: '/backend/persons/get_referees_for_select'
      type: 'GET'
      data: {query}
      success: (data)-> callback(data)


# Кастомные селекты для игроков с ajax поиском на страницу матчей для добавления игрока
# $person = $('#team_person_ids').selectize()
#   plugins: ['remove_button']
#   valueField: 'id',
#   labelField: "name_first",
#   searchField: ['name_first', 'name_last'],
#   create: false,
#   onItemAdd: eventHandler('onItemAdd')

#   render:
#     item: (item, escape)->
#       if item.name_last?
#         return "<div>#{escape(item.name_first)} #{escape(item.name_last)}</div>"
#       else
#         return "<div>#{escape(item.name_first)}</div>"
#     option: (item, escape)->
#       if item.name_last?
#         return "<p>#{escape(item.name_first)} #{escape(item.name_last)}</p>"
#       else
#         return "<div>#{escape(item.name_first)}</div>"
#   load: (query, callback)->
#     if (!query.length) then return callback()
#     $.ajax
#       url: '/backend/persons/get_persons_for_select',
#       type: 'GET',
#       data: {query}
#       success: (data)-> 
#         callback(data);



# person = $person[0]?.selectize

$(document).on 'click', '.close.remove-person', (e)->
  id = $(@).parents('.person').data('id')
  e.preventDefault();
  person.removeItem(id)
  $(@).parents('.person').hide()
  $(@).next().attr('checked', true)