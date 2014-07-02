# Метод запускается, когда мы оказываемся на странице с какой нибудь новостью
# 
Sport.Vent.on 'mark:images:exclusive', ()->
  # определяем является ли новость эксклюзивной
  return unless $('#exclusive').length
  # если да, то на все изображения накладываем метку "Эксклюзивно"
  $('.det_post img').each ->
    $img = $ @
    return if $img.hasClass 'main_image'
    $img.wrap($('<div>').attr('style', $img.attr('style')).css({
      display: 'inline-block'
      position: 'relative'
    }))
    $('<img>',{
      src: '/assets/exclusive.png'
    }).css({
      position: 'absolute'
      margin: 0
      right: 0
      bottom: $img.parent().height() - $img.height()
    }).insertAfter $img
