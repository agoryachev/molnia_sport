var EmbcodeDialog = {
  init : function() {
    var forms = document.forms
    for(var i = 0; i < forms.length; i++) {
      if (forms[i].content) {
        forms[i].content.value = tinyMCEPopup.editor.selection.getContent({format : 'text'});
        break;
      }
    }
  },
  insert : function() {
    var forms = document.forms
    for(var i = 0; i < forms.length; i++) {
      if (forms[i].content) {
        tinyMCEPopup.editor.execCommand('mceInsertContent', false, forms[i].content.value);
        break;
      }
    }
    tinyMCEPopup.close();
  }
};
tinyMCEPopup.onInit.add(EmbcodeDialog.init, EmbcodeDialog);