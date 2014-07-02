class CommentsApp.Models.Comment extends Backbone.Model
  urlRoot: '/comments'
  upRate: (cb)->
    $.get "/comments/#{@id}/update_vote/like", (data)=>
      if data.comment
        {likes, voted_up, voted_down} = data.comment
        @set({likes,voted_up,voted_down})
      else
        @set({likes: data.likes})
      cb(data) if cb

  downRate: (cb)->
    $.get "/comments/#{@id}/update_vote/dislike", (data)=>
      if data.comment
        {likes, voted_up, voted_down} = data.comment
        @set({likes,voted_up,voted_down})
      else
        @set({likes: data.likes})
      cb(data) if cb

class CommentsApp.Collections.Comments extends Backbone.Collection
  model: CommentsApp.Models.Comment
  url: '/comments'

  new: ->
    @models = @newSort(null)
    @trigger 'sorted'

  best: ->
    @models = @so(null)
    @trigger 'sorted'

  so: (parent_id)=>
    tmp = @where({parent_id: parent_id})
    tmp.sort (y, x)->
      return 0 if x.get('likes') is y.get('likes')
      return if x.get('likes') > y.get('likes') then 1 else -1

    tmp2 = []
    # Если parent_id не null то есть не первый уровень комментов
    # мы их ложим в tmp2
    tmp2.push @where({id: parent_id}) if parent_id isnt null

    # проходимся по массиву комментов первого уровня
    for com in tmp
      tmp2.push(com)
      t = @where(parent_id: com.get('id'))
      tmp_each = _.map t, (tm)=>
        @so(tm.get('id'))
      tmp2.push(tmp_each)
    return _.flatten(tmp2)

  newSort: (parent_id)=>
    tmp = @where({parent_id: parent_id})
    tmp.sort (y, x)->
      return 0 if x.get('id') is y.get('id')
      return if x.get('id') > y.get('id') then 1 else -1

    tmp2 = []
    # Если parent_id не null то есть не первый уровень комментов
    # мы их ложим в tmp2
    tmp2.push @where({id: parent_id}) if parent_id isnt null

    # проходимся по массиву комментов первого уровня
    for com in tmp
      tmp2.push(com)
      t = @where(parent_id: com.get('id'))
      tmp_each = _.map t, (tm)=>
        @so(tm.get('id'))
      tmp2.push(tmp_each)
    return _.flatten(tmp2)