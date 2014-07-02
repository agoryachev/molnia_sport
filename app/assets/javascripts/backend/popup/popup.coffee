removeErorrs = ()->
  $('.popup-errors').detach()

if $('.popup-errors')?
  setTimeout removeErorrs, 4000