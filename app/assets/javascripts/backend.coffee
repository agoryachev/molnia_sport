#= require jquery
#= require jquery_ujs

#= require hogan
#= require underscore
#= require backbone

#= require tinymce
#= require underscore
#= require backend/bootstrap
#= require backend/jquery.password
#= require backend/asynch_upload.js
#= require backend/jquery.nmdDatatables
#= require vendor/bootstrap-tokenfield
#= require vendor/bootstrap.hover.dropdown
#= require vendor/jquery.nmdMessages
#= require jquery.ui.sortable

#= require backend/categories
#= require backend/teams
#= require backend/comments
#= require backend/employee
#= require backend/dynamic_object
#= require backend/years
#= require backend/tactical_schemes

#= require backend/persons

#= require moment
#= require moment/ru
#= require vendor/bootstrap-datetimepicker
#= require vendor/to_json

#= require vendor/selectize/selectize
#= require backend/selectize_plugin

#= require_tree ./backend/broadcast_messages

#= require_tree ./vendor/nmd

$ ->
  $('.js-video').each ->
    $video = $ @
    $video.nmdVideoPlayerJw
      setup: $video.data()

  tinyMCE.init
    editor_selector: "tinymce-content"
    theme_advanced_buttons1: "embcode,code,removeformat|,undo,redo,|,bold,italic,underline,|,justifyleft,justifycenter,justifyright,|,hr,bullist,numlist,link,unlink,|,pasteword,image,media,spellchecker,|,fullscreen,|,styleselect,fontselect,fontsizeselect,forecolor"
    plugins: "embcode,paste,media,inlinepopups,spellchecker,fullscreen,advimage,spellchecker"
    # Spellchecker
    spellchecker_languages : "+Russian=ru,Ukrainian=uk,English=en",
    spellchecker_rpc_url : "http://speller.yandex.net/services/tinyspell",
    spellchecker_word_separator_chars : '\\s!"#$%&()*+,./:;<=>?@[\]^_{|}\xa7\xa9\xab\xae\xb1\xb6\xb7\xb8\xbb\xbc\xbd\xbe\u00bf\xd7\xf7\xa4\u201d\u201c',
    # ************
    mode: "specific_textareas"
    theme: "advanced"
    schema: "html5"
    theme_advanced_toolbar_location: "top"
    theme_advanced_toolbar_align: "left"
    theme_advanced_statusbar_location: "bottom"
    theme_advanced_resizing : true
    theme_advanced_buttons2: null
    theme_advanced_buttons3: null
    convert_fonts_to_spans: false
    paste_auto_cleanup_on_paste: true
    force_br_newlines: true
    force_p_newlines: false
    relative_urls: false
    dialog_type: "modal"
    skin: "o2k7"
    language: "ru"
    spellchecker_languages: "+Russian=ru,Ukrainian=uk,English=en"
    spellchecker_rpc_url: "http://speller.yandex.net/services/tinyspell"
    spellchecker_word_separator_chars: "\\\\s!\"#$%&()*+,./:;<=>?@[\\]^_{|}\\xa7\\xa9\\xab\\xae\\xb1\\xb6\\xb7\\xb8\\xbb\\xbc\\xbd\\xbe\\u00bf\\xd7\\xf7\\xa4\\u201d\\u201c"
    spellchecker_report_no_misspellings: false
    remove_script_host: false
    valid_elements : '*[*]'
    file_browser_callback: (field, url, type, win) ->
      tinyMCE.activeEditor.windowManager.open
        file: "/backend/media/uploader_tinymce?type=#{type}"
        title: "Спорт :: Медиабиблиотека"
        width: 700
        height: 500
        inline: true
        close_previous: false
      ,
        window: win
        input: field
      false

  $(document).on 'input', '#search', (e)->
    $(this).parents("form").submit()

if $('.errors').length > 0
  hideMessage = ->
    $('.errors').remove()
  setTimeout(hideMessage, 2000)

$ ->
  # Выбор даты
  $('#datetimepicker_time').datetimepicker
    language: 'ru'
    pickTime: false
  # Выбор даты и времени
  $('#datetimepicker_datatime').datetimepicker
    language: 'ru'

  window.refreshDatetimepicker = ()->
    $('.datetimepicker').datetimepicker(language: 'ru')
    $('.datetimepicker_time').datetimepicker
      language: 'ru'
      pickDate: false
      pick12HourFormat: false
  window.refreshDatetimepicker()


#
# Обработчики Ajax форм
#
$(document).on 'change', 'form.ajax', (e)-> $(this).submit()
$(document).on 'ajax:success', 'form.ajax', (s, data, x)->

  switchStyleForElement = (id)->
    $el = $("[data-id='#{id}']")
    $el.toggleClass('muted')

  if data.errors is undefined
    showNotices data.msgs, ()->
    if data.id isnt undefined
      switchStyleForElement(data.id)
      $('.modal').modal('hide')
  else
    showErrors(data.errors)

$(document).on 'ajax:error', 'form.ajax', (s, data, x)->
  showErrors(x)

$(document).on 'click', '#js-check-all', (e)->
  e.preventDefault();
  $target = $("input[name='#{$(this).data('target')}']");
  $target.prop('checked', !$target.prop('checked'))

$(document).on 'click', '#league_is_published, #inside_is_published, #person_is_published, #team_is_published, #gallery_is_published', (e)->
  $(@).parents('tr').toggleClass('muted')


# Добавление тегов
$('#post_tag_list, #gallery_tag_list').tokenfield()


$(document).on 'click', '.trash-button', (e)->
  e.preventDefault()
  $link = $(@)
  $link.find('.destroy_image').attr('value', 1)
  $link.closest("li").hide()

$(document).on 'change', '#leagues_group_round_type', (e)->
  el = $(e.target);
  if parseInt(el.val())
    $('#leagues_group_start_stage').parents('.form-group').removeClass('hidden');
  else
    $('#leagues_group_start_stage').parents('.form-group').addClass('hidden');
    $('#leagues_group_start_stage').val('');

