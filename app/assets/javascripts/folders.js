$(document).ready( function() {
  if($("#ctrllr-folders").length >0 ){
    if($("#folders-index").length >0 ){
      var parent_path = "#parent_path";
      var parent_id = "#parent_id";

      $("#tree").fancytree({
        lazy: true,
        extensions: ["dnd"],
        
        //checkbox: true,
        selectMode: 1,
        source: $.ajax({
          url: "folders",
          dataType: "json"
        }),
        lazyLoad: function(event, data){
          var node = data.node;
          // Issue an ajax request to load child nodes
          data.result = {
            url: "folders.json",
            data: {id: node.key}
          }
        },
        activate: function(event, data) {
          if(data.node.folder){
            $(parent_id).val(data.node.key); 
            var parents = data.node.getParentList();
            var p = "";
            for(var i = 0; i < parents.length; i++)
              p += parents[i].title;
            p += data.node.title;
            $(parent_path).html(p);
          }
        },
        dnd: {
            autoExpandMS: 400,
            focusOnClick: true,
            preventVoidMoves: true, // Prevent dropping nodes 'before self', etc.
            preventRecursiveMoves: true, // Prevent dropping nodes on own descendants
            dragStart: function(node, data) {
                // if false dnd is disabled
                return true;
            },
            dragStop: function(node, data) {
                return true;
            },
            dragEnter: function(node, data) {
                if(node.parent !== data.otherNode.parent) return false;
                return true;
            },
            dragDrop: function(node, data) {
              // if dropped to another node insert it before!
              data.otherNode.moveTo(node, "before");
            }
        },
      });

      $("#folders-index form_new").on("submit",function(evt){
            var serial = $(this).serialize();
            var action = $(this).attr('action');
            evt.preventDefault();
            $.ajax({
              type: "POST",
              url: action,
              data: serial,
              dataType: "json",
              success: function(data){
                var node = {key: data['id'], title: data['name'], folder: 'true', lazy: 'true'};
                var tree = $("#tree").fancytree("getTree");
                var active_node = tree.getActiveNode();
                if(! active_node){
                  active_node = tree.rootNode.children[0];
                }
                active_node.addChildren(node);
                console.log(data);
                return false;
              },
              error: function(xhr, event, status) {
                var errors = jQuery.parseJSON(xhr.responseText);
                //showError(eldoc.container.error, errors);
                console.log(errors);
                return false;
              }
            });
            return false;
      });

    }
  }

});
  
