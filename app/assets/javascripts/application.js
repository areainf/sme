// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require dataTables/jquery.dataTables
//= require jquery.tokeninput.js
//= require parsley
//= require parsley.i18n.es

//#m+ 
//= require bootstrap-sprockets


//= require_tree .
/* require turbolinks*/

// $('.tabs a').click(function (e) {
//   e.preventDefault();
// console.log("Abrir tabs");
//   $(this).tab('show');
// })

EntityJson = function(data){
  if(data != undefined){
    if ( typeof data == "string"){
      data = jQuery.parseJSON(data);
    }
    this.id = data['id'];
    this.person_id = data['person_id'];
    this.dependency_id = data['dependency_id'];
    this.employment_id = data['employment_id'];
    this.active = data['active'];
    this.person = new PersonJson(data['person']);
    this.dependency = new DependencyJson(data['dependency']);
    this.employment = new EmploymentJson(data['employment']);
    this.fullEntityName = function(){
      var name = this.person.fullPersonName();
      var dname = this.dependency.name;
      var ename = this.employment.name;
      if(dname){
        if(name.length > 0)
          name += " ";
        name += "[" + dname + ']';
      }
      if(ename){
        if(name.length > 0)
          name += " ";
        name += '(' + ename + ')';
      }
      return name;
    }
  }
}
PersonJson = function(data){
  if(data != undefined){
    if ( typeof data == "string")
      data = jQuery.parseJSON(data);
    this.id = data['id'];
    this.firstname = data['firstname'];
    this.lastname = data['lastname'];
  }
  this.fullPersonName = function(){
    var name = (this.firstname != undefined) ? this.firstname : '';
    if(this.lastname != undefined){
      if (name.length > 0)
        name += ", ";
      name += this.lastname;
    }
    return name;

  }
}
DependencyJson = function(data){
  if(data != undefined){
    if ( typeof data == "string")
      data = jQuery.parseJSON(data);
    this.id = data['id'];
    this.name = data['name'];
  }
}
EmploymentJson = function(data){
  if(data != undefined){
    if ( typeof data == "string")
      data = jQuery.parseJSON(data);
    this.id = data['id'];
    this.name = data['name'];
  }
}

$(document).ready(function() {
  goto_tab_if_defined();
});

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