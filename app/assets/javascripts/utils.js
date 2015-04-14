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

/*Mostrar errores dinamicanete*/
function showError(hash_error, container){
  //set default value for container  
  VARR = hash_error;
  container = typeof container !== 'undefined' ? container : "#ajax_error_container";
  if (hash_error instanceof Array){
    hash_error = {errors: {0: hash_error}};
  }
  var text = '<div class="alert  alert-error"> \
              <button type="button" class="close" data-dismiss="alert">&times;</button>\
              <h4>Error</h4> \
              <ul>';
  for(var key in hash_error.errors){
    var t = hash_error.errors[key];
    console.log(t);
    if (t instanceof String)
      text += "<li>" + t + "</li>";
    else{
      for(var i = 0; i < t.length; i++){
        text += "<li>" + t[i] + "</li>";
      }
    }
  }
  text += '</ul></div>';
  $(container).html(text);
}

$(document).ready(function() {
  goto_tab_if_defined();
});
