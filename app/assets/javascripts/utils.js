/*Si la url tiene especificado algun tab "#name" entonces
  si existe name activar ese tab
  */
function goto_tab_if_defined(){
  var hash = location.hash;
  var hashPieces = hash.split('?');
  if(hashPieces[0]){
    var activeTab = $('[href=' + hashPieces[0] + ']');
    activeTab && activeTab.tab('show');
  }
}
/*Mostrar mensajes dinamicanete*/
function showMessage(messages, container){
  //set default value for container  
  container = typeof container !== 'undefined' ? container : "#ajax_error_container";
  if (! (messages instanceof Array)){
    messages = [messages];
  }
  var text = '<div class="alert alert-success"> \
              <button type="button" class="close" data-dismiss="alert">&times;</button>\
              <h4>Mensajes</h4> \
              <ul>';
  for(var i = 0; i < messages.length; i++){
      text += "<li>" + messages[i] + "</li>";
  }
  text += '</ul></div>';
  $(container).html(text);
}
/*Mostrar errores dinamicanete*/
function showError(hash_error, container){
  //set default value for container
  container = typeof container !== 'undefined' ? container : "#ajax_error_container";
  if (hash_error instanceof Array){
    hash_error = {errors: {0: hash_error}};
  }
  var text = '<div class="alert alert-danger"> \
              <button type="button" class="close" data-dismiss="alert">&times;</button>\
              <h4>Error</h4> \
              <ul>';
  if(typeof hash_error.errors == 'string' || hash_error.errors instanceof String)
    text += "<li>" + hash_error.errors + "</li>";
  else{
    for(var key in hash_error.errors){
      var t = hash_error.errors[key];
      if (t instanceof String)
        text += "<li>" + t + "</li>";
      else{
        for(var i = 0; i < t.length; i++){
          text += "<li>" + t[i] + "</li>";
        }
      }
    }
  }
  text += '</ul></div>';
  $(container).html(text);
}
function removeError(container){
  container = typeof container !== 'undefined' ? container : "#ajax_error_container";
  $(container).html("");
}
$(document).ready(function() {
  goto_tab_if_defined();
});
