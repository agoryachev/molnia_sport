class BroadcastMessages.Views.MessagesTimeline extends Backbone.View
  el: '#messages'
  template: ["<tr>",
    "<td>{id}</td>",
    "<td>{time}</td>",
    "<td class='centered'><img src='{event}'></td>",
    "<td>{text}</td>",
    "<td width='5%' data-id='{id}' data-url='/backend/matches/{match_id}/broadcast_messages/{id}'>",
      "<a class='btn btn-danger btn-sm w-c'>",
        "<span class='glyphicon glyphicon-trash'></span>",
      "</a>",
    "</td>"
  "</tr>"]

  events:
    'click .btn-danger': 'deleteEvent'

  initialize: ->
    @matchId = location.pathname.split('/').pop()
    @listenTo BroadcastMessages.Vent, 'event:added', @addEvent
    @listenTo @, 'event:deleted', @eventDeleted
    @messagesLineTbody = @$el.find('tbody')
    @template = @template.join('')

  addEvent: (data)->
    @messagesLineTbody
      .prepend(
        @template
          .replace(/\{id\}/g, data.result.message.id)
          .replace('{time}', data.result.message.time)
          .replace('{event}', data.result.event?.image || '')
          .replace('{text}', data.result.message.text)
          .replace('{match_id}', @matchId))

  deleteEvent: (e)->
    e.preventDefault()
    td = $(e.target).parents('td')
    td.hide()

    send = $.ajax
      url: td.data('url')
      data: {id: td.data('id')}
      type: 'DELETE'
    send.done (data)=> @trigger 'event:deleted', data, td


  eventDeleted: (data, td = null)->
    if data.success?
      showNotices('Событие удалено')
      td.parents('tr').detach()