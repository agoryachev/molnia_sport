//= require backend/jquery.uploadOne
//= require backend/jquery.uploadQueue
'use strict';

$(function() {
  var $imageBlock = $('#image_block');
  $imageBlock.uploadOne($imageBlock.data());

  var $audioBlock = $('#audio_block');
  $audioBlock.uploadOne($audioBlock.data());

  var $videoBlock = $('#video_block');
  $videoBlock.uploadOne($videoBlock.data());

  var $queuePlupload = $('#queue_plupload');
  $queuePlupload.uploadQueue($queuePlupload.data());
});