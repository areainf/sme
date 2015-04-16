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
    if(this.lastname != undefined &&  this.lastname.length > 0){
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
EventJson = function(data){
  if(data != undefined){
    if ( typeof data == "string")
      data = jQuery.parseJSON(data);
    this.id = data['id'];
    this.description = data['description'];
    this.date = data['date'];
    this.dateEs = function(){
      var m = moment(this.date);
      return m.format("DD/MM/YYYY");
    }
  }
}