/**
 * jQuery uploadOne
 * http://go-promo.ru
 * Version: 0.1
 * GIT: https://bitbucket.org/Jerry_/jquery-plugins
 * Copyright 2013 Go-Promo
 */

//= require jquery
//= require vendor/nmd/jquery.nmdVideoPlayerJw
//= require backend/plupload/plupload.full
//= require backend/plupload/jquery.plupload.queue
//= require backend/plupload/i18n/ru
//= require backend/jquery-waiting

//= require_self
'use strict';

(function($) {
  var PLUGIN_NAME = 'uploadOne';
  //name uploading file, it's need for abort
  var fileName;
  var methods = {
    init: function(options) {
      var settings = $.extend(true, {
        container: null,
        url: null,
        maxSize: '1gb',
        chunkSize: '100kb',
        filterTitle: 'Image',
        filterExtensions: 'jpg,jpeg,gif,png',
        runtimes: 'html5'
      }, options);

      var toggleActionsBtns = function(status) {
        status = status || false;
        if (status) {
          $('.form-actions .btn').fadeOut();
        } else {
          $('.form-actions .btn').fadeIn();
        }
      }

      var addPlayingMediaBlock = function($block, id, fileUrl, typeMedia) {
        var fieldName;
        if(typeMedia == 'audio')
          fieldName = 'record';
        else
          fieldName = 'clip';
        
        $('#' + typeMedia + '_' + fieldName + '_attributes_id').remove();
        $block.find('object').remove();
        $block.find(typeMedia).remove();

        $block
          .prepend($('<input>', {
            id: typeMedia + '_' + fieldName + '_attributes_id',
            name: typeMedia + '[' + fieldName + '_attributes][id]',
            type: 'hidden',
            value: id
          }))
          .prepend($('<' + typeMedia + '>', {
            controls: true
          }).append($('<source>', {
            src: fileUrl
          })));
        $block.find('label.checkbox').show();        
        $block.find(typeMedia).each(function(i,el){
          var file = $(el).find('source').attr("src");
          var $el = $(el).attr('id', typeMedia + '_player_'+i);
          if(typeMedia == 'audio')
            console.log("Audio player isn't implemented.");
          else //video
            $el.nmdVideoPlayerJw({
              setup: {
                file: file,
                width: 525,
                height: 315
              },
            });
        });
        $block.parents("form").find('#' + typeMedia + '_' + fieldName + '_attributes_id').val(id);
      }

      var addImageBlock = function($imageBlock, id, name, fileUrl, type){       
        $("#" + type + "_main_image_attributes_id").remove();
        $imageBlock.find("img").remove();
        $imageBlock
          .prepend($('<input>', {
            id: type + '_main_image_attributes_id',
            name: type + '[main_image_attributes][id]',
            type: 'hidden',
            value: id
          }))
          .prepend($('<img>', {
            alt: name,
            class: 'thumbnail',
            src: fileUrl
          }));
        $imageBlock.find('label.checkbox').show();
      }

      var addMediaUrl = function(fileUrl, typeMedia){
        if(typeMedia == 'video') {
          var arr, type;

          arr = fileUrl.split('.');
          type = arr[arr.length-1];

          $('#mp4 a').remove();
          $('#webm a').remove();

          $('#mp4').text('');
          $('#webm').text('');

          if(type === 'mp4') {
            $('#mp4').append('<a href="' + fileUrl +'">' + fileUrl + '</a>');
          } else {
            $('#mp4').text('Не существует');
          }
          
          if(type === 'webm') {
            $('#webm').append('<a href="' + fileUrl +'">' + fileUrl + '</a>');
          } else {
            $('#webm').text('Не существует');
          }
        }
      }

      return this.each(function() {
        if (!settings.container) {
          $.error('plupload settings.container is missing for ' + PLUGIN_NAME);
        }

        if (!settings.url) {
          $.error('plupload settings.url is missing for ' + PLUGIN_NAME);
        }

        var $container = $('#' + settings.container);
        var $button = $('#' + settings.container + '_button');
        var $buttonStop = $container.find(".js-stop-upload");
        var $buttonsStart = $('.js-start-upload');

        var abortAjax = function() {
          $.ajax({
            type: "PUT",
            url: settings.url,
            data: {
              _plupload_upload: 'plupload_upload',
              status: 'abort',
              filename: fileName
            }
          });
        }

        var multi_params = {
          authenticity_token: $("input[name=authenticity_token]").val(),
          _method: 'put',
          _plupload_upload: 'single'
        }        
        
        var uploader = new plupload.Uploader({
          runtimes: settings.runtimes,
          browse_button: settings.container + '_button',
          max_file_size: settings.maxSize,
          chunk_size: settings.chunkSize,
          url: settings.url,
          multi_selection: false,
          init: {
            FilesAdded: function(up, files) {   

              var $videoBlock = $($container.parent().find('#video_block')[0]);
              if ($videoBlock) {
                $videoBlock.empty();
              }

              //$('#waiting_circle').waiting('enable');
              fileName = files[0].name;
              $container.find('.progress-bar')
                .css('width', '5%');
              $container.find('.upload-label')
                .text('5%')
                .show();
              $container.closest('.controls').find('.help-block').hide();
              $container.filter('.upload-progress-bar')
                .show('fast', function() {
                  up.start();
                });
              $.extend(multi_params,{snapshot_time: $('input[name=snapshot_time]').val()});
            },
            UploadProgress: function(up, file) {
              if (file.percent < 100) {
                $container.find('.progress-bar').css('width', file.percent + '%');
                $container.find('.upload-label').text(file.percent + '%');
              }

              if (file.percent > 80) {
                $buttonStop.attr('disabled', true);
              }
            },
            FileUploaded: function(up, file, r) {
              var response = $.parseJSON(r.response);
              if (response.type == 'video') {
                
                var $videoBlock = $('#video_block');
                addPlayingMediaBlock($videoBlock, response.id, response.file_url, 'video');

                addMediaUrl(response.file_url, 'video');
                
                var $imageBlock = $('#image_block');
                var name = response.image_url.slice(response.image_url.lastIndexOf('/') + 1, response.image_url.lastIndexOf('.'));
                addImageBlock($imageBlock, response.image_id, name, response.image_url, settings.entity);              
                showNotices('Видео успешно добавлено');
              } else if(response.type == 'audio') {
                var $audioBlock = $('#audio_block');
                addPlayingMediaBlock($audioBlock, response.id, response.file_url, 'audio');
                showNotices('Аудио успешно добавлено');
              } else if(response.type == 'image') {
                var fileUrl = response.file_url;
                var name = fileUrl.slice(fileUrl.lastIndexOf('/') + 1, fileUrl.lastIndexOf('.'));
                var $imageBlock = $('#image_block');
                var $imageBlockImg = $imageBlock.find('img');
                addImageBlock($imageBlock, response.id, name, fileUrl, settings.entity);
                showNotices('Изображение успешно добавлено');
              }

              up.stop();
            },
            Error: function(up, error) {
              if (error.status) {
                showErrors('Ошибка загрузки на сервер: ' + error.status);
                up.stop();
              } else {
                showErrors(error.message + error.file.name);
              }
            },
            // тут прописываются своства UI в зависимости от состояния загрузчика
            StateChanged: function(up) {
              if (up.state == plupload.STOPPED) {
                up.refresh();
                up.splice();
                $button.show();
                $container.filter('.upload-progress-bar').hide();
                $container.closest('.controls').find('.help-block').show();
                $buttonsStart.attr('disabled', false);
                toggleActionsBtns(false);
              } else if (up.state == plupload.STARTED) {
                $button.hide();
                $buttonsStart.attr('disabled', true);
                $buttonStop.attr('disabled', false);
                toggleActionsBtns(true);
              }
            },
          },
          multipart_params: multi_params,
          filters: [{
            title: settings.filterTitle,
            extensions: settings.filterExtensions
          }],
          file_data_name: 'file'
        });

        $buttonStop.on('click', function(e) {
          e.preventDefault();
          uploader.stop();
          abortAjax();
        });

        // $(window)
        //   .on('beforeunload', function(){
        //     if (uploader.state == plupload.STARTED) {
        //       return "Идёт загрузка файлов. Вы уверены, что хотите уйти со страницы?";
        //     }
        //   })
        //   .on('unload', function(){
        //     if (uploader.state == plupload.STARTED) {
        //       abortAjax();
        //     }
        //   });

        uploader.init();
      });
    }
  }

  $.fn.uploadOne = function(method) {
    if (methods[method]) {
      return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if (typeof method === 'object' || !method) {
      return methods.init.apply(this, arguments);
    } else {
      $.error('Метод с именем ' + method + ' не существует для jQuery.' + PLUGIN_NAME);
    }
  };

})(jQuery);