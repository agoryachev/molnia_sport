/**
 * jQuery uploadQueue
 * http://go-promo.ru
 * Version: 0.1
 * GIT: https://bitbucket.org/Jerry_/jquery-plugins
 * Copyright 2013 Go-Promo
 */

//= require jquery
//= require backend/plupload/plupload.full
//= require backend/plupload/jquery.plupload.queue
//= require backend/plupload/i18n/ru
//= require_self
'use strict';

(function($) {
  var PLUGIN_NAME = 'uploadQueue';
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

      var addItem = function(id, model_id, name, file_url, type) {
        var gallery_files_id = _.last(arguments);
        var $thumbnails = $('ul.thumbnails');
        var position = $thumbnails.children('li').length;
        var position_id = 0;
        var temp = $("input[id^=gallery_gallery_files_attributes_]:last").attr("id");
        if(typeof(temp) != 'undefined'){
          temp = temp.match(/gallery_gallery_files_attributes_(\d+)/i);
          if(typeof(temp) != 'undefined'){
            position_id = parseInt(temp[1]) + 1;
          }
        }
        _.templateSettings = {
          interpolate: /\{\{(.+?)\}\}/g
        };
        var template = _.template($('#gallries-foto-template').html());
        var compiled = template({name:name, file_url: file_url, model_id:model_id, id:id, position_id:position_id, type:type, position:position, gallery_files_id:gallery_files_id})
        $thumbnails.append(compiled);
      }
      
      var toggleActionsBtns = function(status) {
        status = status || false;
        if (status) {
          $('.btn').fadeOut();
        } else {
          $('.btn').fadeIn();
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
        var $buttonStop = $container.closest('.controls').find(".js-stop-upload");

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

        $container.pluploadQueue({
          runtimes: settings.runtimes,
          max_file_size: settings.maxSize,
          chunk_size: settings.chunkSize,
          url: settings.url,
          multipart_params: {
            authenticity_token: $("input[name=authenticity_token]").val(),
            _method: 'put',
            _plupload_upload: 'queue'
          },
          filters: [{
            title: settings.filterTitle,
            extensions: settings.filterExtensions
          }],
          file_data_name: 'file',
          init : {
            StateChanged: function(up) {
              if (up.state == plupload.STARTED) {
                toggleActionsBtns(true);
                $buttonStop.show();
              } else {
                showNotices('Изображения успешно добавлены');
                toggleActionsBtns(false);
                $buttonStop.hide();
              }
            },
            BeforeUpload: function(up, file) {
              fileName = file.name;
              $buttonStop.attr('disabled', false);
            },
            UploadProgress: function(up, file) {
              if (file.percent > 80) {
                $buttonStop.attr('disabled', true);
              }
            },
            FileUploaded: function(up, file, r) {
              var response = $.parseJSON(r.response);
              var file_url = response.file_url;
              var name = file_url.slice(file_url.lastIndexOf('/') + 1, file_url.lastIndexOf('.'));
              if (response.gallery_files_id){
                var gallery_files_id = response.gallery_files_id;
                addItem(response.id, response.model_id, name, file_url, settings.entity, gallery_files_id);
              }else{
                addItem(response.id, response.model_id, name, file_url, settings.entity);
              }

              if (up.files.length == (up.total.uploaded + up.total.failed)) {
                up.stop();
                up.splice();
                $container.find('.plupload_buttons').show();
                $container.find('.plupload_upload_status').hide();
              }
            }
          }
        });
        //hack for delete alert when error occur. ask skrinits.
        var uploader = $container.pluploadQueue();
        uploader.unbind('Error');
        uploader.bind('Error', function(up, error){
          if (error.status) {
            showErrors('Ошибка загрузки на сервер: ' + error.status);
            up.stop();
            up.splice();
            $container.find('.plupload_buttons').show();
            $container.find('.plupload_upload_status').hide();
          } else {
            showErrors(error.message + error.file.name);
          }
        });

        $container.closest('.controls').find(".js-stop-upload").on('click', function(e) {
          e.preventDefault();
          var up = $container.pluploadQueue();
          up.stop();
          up.splice();
          $container.find('.plupload_buttons').show();
          $container.find('.plupload_upload_status').hide();
          abortAjax();
        });

      });
    }
  }

  $.fn.uploadQueue = function(method) {
    if (methods[method]) {
      return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if (typeof method === 'object' || !method) {
      return methods.init.apply(this, arguments);
    } else {
      $.error('Метод с именем ' + method + ' не существует для jQuery.' + PLUGIN_NAME);
    }
  };

})(jQuery);