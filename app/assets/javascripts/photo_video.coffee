# на странице фото видео при выборе категории в селекте подставить значение в урл и сделать Ajax запрос
$('form.news_filter').find('select').on 'change', (e)->
  e.preventDefault()
  defaultUrl = getDefaultUrl()
  val = $(@).val()
  if _.isEmpty(val)
    return location.href = '/photo_video'
  location.href = if /category/.test(defaultUrl)
    url = defaultUrl.replace(/category\/(\d+)/, "category/#{val}")
    url
  else
    "#{defaultUrl}/category/#{val}"

$('form.news_filter').find('a').on 'click', (e)->
  e.preventDefault()
  changeActiveButton($(@))
  defaultUrl = getDefaultUrl()

  filter = if $(@).text() is 'НОВОЕ' then 'new' else 'popular'
  location.href = if /filter/.test(defaultUrl)
    url = defaultUrl.replace(/filter\/(\w+)/, "filter/#{filter}")
    url
  else
    "#{defaultUrl}/filter/#{filter}"

getDefaultUrl = ()->
  location.href

changeActiveButton = (button)->
  $aTags = $('form.news_filter').find('a')
  $aTags.removeClass('active')
  button.addClass('active')