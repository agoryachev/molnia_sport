class BroadcastMessages.Views.Form extends Backbone.View
  el: '#new_broadcast_message'

  events:
    'submit': 'submitForm'
    'click a[data-toggle="tab"]': 'changeEventType'

  initialize: ->
    @listenTo @, 'different:team', @differentTeamError
    @listenTo @, 'same:player', @samePlayer
    @listenTo @, 'wrong:goal:team', @wrongGoalTeam
    @listenTo BroadcastMessages.Vent, 'event:added', @eventAdded

    @action = @$el.attr('action')

  submitForm: (e)->
    e.preventDefault()
    serializedForm = $(e.target).serializeObject()
    action = "check#{serializedForm.broadcast_message.event_type}"

    if action in ['checkgoal', 'checkreplacement']
      @sendAjax(serializedForm) if @[action](serializedForm)
    else
      @sendAjax(serializedForm)

  sendAjax: (formData)->
    $.ajax
      url: @action
      data: formData
      type: 'POST'
      success: (data)=> BroadcastMessages.Vent.trigger 'event:added', data


  # При клике по табу, высталяем тип события для формы
  changeEventType: (e)->
    type = $(e.target).data('event-type')
    @$el.find('input[name="broadcast_message[event_type]"]').val(type)

  # Валидация гола
  checkgoal: (serializedForm)->
    selectedPlayerteam = @selectedPlayerTeam('#broadcast_message_goal_player_id')
    selectedteam = @selectedOption('#broadcast_message_goal_team_id')

    # Если выбран игрок не из команды которая забила
    if selectedPlayerteam isnt selectedteam
      @trigger 'wrong:goal:team'
      return false
    return true


  # Валидация замены
  checkreplacement: (serializedForm)->
    outTeam = @selectedPlayerTeam('#broadcast_message_replacement_player_out_id')
    inTeam = @selectedPlayerTeam('#broadcast_message_replacement_player_in_id')
    replacement = serializedForm.broadcast_message.replacement

    # Если выбран один и тот же игрок
    if replacement.player_in_id is replacement.player_out_id
      @trigger 'same:player'
      return false
    # Если выбраны игроки из разных команд
    if outTeam isnt inTeam
      @trigger 'different:team'
      return false

    return true

  # Получаем название команды выбранного игрока
  selectedPlayerTeam: (select)->
    @$el
      .find("#{select} option:selected")
      .parents('optgroup')
      .attr('label')
      .trim()

  selectedOption: (select)->
    @$el
      .find("#{select} option:selected")
      .text()
      .trim()

  differentTeamError: -> 
    showErrors('Игроки должны быть одной команды')
    return false
  samePlayer: -> 
    showErrors('Игроки должны быть разные')
    return false
  wrongGoalTeam: -> 
    showErrors('Игрок должен быть из команды которая забила гол')
    return false

  # Когда событие создано, оповещаем об этом, очищаем форму и выставляем первый таб
  eventAdded: ->
    showNotices('Событие добавлено')
    @el.reset()
    $('a[href="#none"]').tab('show')