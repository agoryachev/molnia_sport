$galleryPreviews = $('.gallery-previews').find('a')
$galleryPreviewsInner = $('.gallery-previews-inner')
firstImageSrc = $galleryPreviews.first().attr('href')
$mainGalleryImage = $('.main-gallery-image').find('img')
$mainGalleryImage.attr('src', firstImageSrc)

$galleryPreviews.on 'click', (e)->
  e.preventDefault()
  return if $(@).attr('href') is $mainGalleryImage.attr('src')
  $mainGalleryImage.fadeOut 500, ()=>
    $mainGalleryImage.attr('src', $(@).attr('href')).load ()->
      $mainGalleryImage.fadeIn 500

imgsCount = $('.gallery-previews').find('img').length
imgWidth = $('.preview img').width()


current = 1
margin = 10
blockWidth = 620
currentMax = Math.round(imgsCount / 5)

$('.click').click (e)->
  e.preventDefault()
  direction = $(@).data('dir')
  current = 1 if current <= 0
  if direction is 'next' then current += 1 else current -= 1

  if current <= currentMax
    unit = if direction is 'next' then '-=' else '+='

    if current isnt 0
      $galleryPreviewsInner.animate
        'left': if unit then (unit+(blockWidth + margin)) else (blockWidth + margin)
  else
    $galleryPreviewsInner.animate({'left': "0px"})
    current = 0