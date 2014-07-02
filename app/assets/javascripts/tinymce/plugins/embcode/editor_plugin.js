(function() {
  tinymce.create('tinymce.plugins.EmbcodePlugin', {
    init : function(ed, url) {
      ed.addCommand('mceembcode', function() {
        ed.windowManager.open({
          file : url + '/modal.htm',
          width : 500 + ed.getLang('embcode.delta_width', 0),
          height : 300 + ed.getLang('embcode.delta_height', 0),
          inline : 1
        }, {
          plugin_url : url,
          some_custom_arg : 'custom arg'
        });
      });
      ed.addButton('embcode', {
        title : 'Вставка Инстраграмма или Твиттера в поле',
        cmd : 'mceembcode',
        image : url + '/img/missing.jpg'
      });
      ed.onNodeChange.add(function(ed, cm, n) {
        cm.setActive('embcode', n.nodeName == 'IMG');
      });
    },
    createControl : function(n, cm) {
      return null;
    }
  });
  tinymce.PluginManager.add('embcode', tinymce.plugins.EmbcodePlugin);
})();