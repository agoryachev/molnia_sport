# Метод запускается, когда мы оказываемся на
# странице с какой нибудь новостью
# 
Sport.Vent.on 'set:image:title:alt', ()->
  # Вывод заголовка и описания изображения
  parent = document.querySelector('.det_post')
  imgs = parent.querySelectorAll('img')

  for image in imgs
    continue if image.className is 'main_image'

    title = image.getAttribute('title')
    alt = image.getAttribute('alt')
    if(alt != 'undefined')
      elem = document.createElement('div')
      elem.textContent = alt
      elem.className = 'image_descr'
      $(elem).insertAfter(image)

    if(title != 'undefined')
      elem = document.createElement('h2')
      elem.textContent = title
      elem.className = 'image_title'
      $(elem).insertAfter(image)