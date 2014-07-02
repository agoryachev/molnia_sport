$block = $('.calendar .calendar-slider')
$galleryPreviewsInner = $block.find('.slider-fix-height')



imgsCount = $block.find('.row-slide').length
imgWidth = 220


currentMax = Math.min(imgsCount / 4)
current = currentMax

blockWidth = 878

$(document).on 'click', '.click', (e)->
  e.preventDefault()
  direction = $(@).data('dir')
  
  if current <= 0
    current = 0 

  if direction is 'next' 
    current += 1 
  else 
    current -= 1
  
  if current < 0
    current = 0
    return
  if current <= currentMax
    unit = if direction is 'next' then '+=' else '-='

    if current isnt 0
      $galleryPreviewsInner.animate
        'right': if unit then (unit+(blockWidth)) else blockWidth
    else
      $galleryPreviewsInner.animate({'right': "0px"})
  else
    $galleryPreviewsInner.animate({'right': "0x"})
    current = currentMax