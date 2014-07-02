/**
 * jQuery nmdMessages
 * http://go-promo.ru
 * Version: 0.4
 * GIT: https://bitbucket.org/Jerry_/jquery-plugins
 * Copyright 2013 Go-Promo
 */

function showMessageBridge(msgs, type, fadeInCallback) {
  type = type || 'notice';
  fadeInCallback = fadeInCallback || function() {}
  var $nb = $('.notice-bar');
  $nb.empty().removeClass().addClass('notice-bar').addClass(type);

  if (typeof msgs == 'string') {
    $nb.append($("<li>", {
      text: msgs
    }));
  } else if (typeof msgs == 'object') {
    $.each(msgs, function() {
      $nb.append($("<li>", {
        text: this
      }));
    });
  }
  $nb.fadeIn(function() {
    fadeInCallback.apply(window);
  }).delay(2000).fadeOut();
}

function showNotices(msgs, fadeInCallback) {
  showMessageBridge(msgs, 'notice', fadeInCallback);
}

function showErrors(msgs, fadeInCallback) {
  showMessageBridge(msgs, 'error', fadeInCallback);
}