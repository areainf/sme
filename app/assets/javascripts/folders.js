$(document).ready( function() {
  if($("#ctrllr-folders").length >0 ){
    if($("#folders-index").length >0 ){
      var parent_path = "#parent_path";
      var parent_id = "#parent_id";

      $("#tree").fancytree({
        lazy: true,
        extensions: ["dnd", "edit"],
        
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
            /** This function MUST be defined to enable dragging for the tree.
             *  Return false to cancel dragging of node.
             */
            return true;
          },
          dragEnter: function(node, data) {
            /** data.otherNode may be null for non-fancytree droppables.
             *  Return false to disallow dropping on node. In this case
             *  dragOver and dragLeave are not called.
             *  Return 'over', 'before, or 'after' to force a hitMode.
             *  Return ['before', 'after'] to restrict available hitModes.
             *  Any other return value will calc the hitMode from the cursor position.
             */
            // Prevent dropping a parent below another parent (only sort
            // nodes under the same parent)
            /*if(node.parent !== data.otherNode.parent){
              return false;
            }
            // Don't allow dropping *over* a node (would create a child)
            return ["before", "after"];
            */
             return true;
          },
          dragDrop: function(node, data) {
            /** This function MUST be defined to enable dropping of items on
             *  the tree.
             * expand if lazy load
              console.log("MOVER "+data.otherNode.key+ " a "+node.key);
             */
            node.setExpanded(true).always(function(){
              // Wait until expand finished, then add the additional child
              move(data,node);
            });
          }
        },
        edit: {
          triggerStart: ["f2", "dblclick", "shift+click", "mac+enter"],
          beforeEdit: function(event, data){
            // Return false to prevent edit mode
          },
          edit: function(event, data){
            // Editor was opened (available as data.input)
          },
          beforeClose: function(event, data){
            // Return false to prevent cancel/save (data.input is available)
          },
          save: function(event, data){
            // Save data.input.val() or return false to keep editor open
            rename(data);
            return true;
          },
          close: function(event, data){
            // Editor was removed
            if( data.save ) {
              // Since we started an async request, mark the node as preliminary
              $(data.node.span).addClass("pending");
            }
          }
        }
      });

      $("#folders-index form_new").on("click",function(evt){
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
      
      /*Mover carpeta y documento desde hasta*/
      function move(_data, node){
        //ok = mover_document(data.otherNode.key, node.key);
                //data.otherNode.moveTo(node, data.hitMode);
        var params = {id_from: _data.otherNode.key, id_to: node.key};
        var url = "move_document";
        if(_data.otherNode.folder)
          url = "move_folder";
        $.ajax({
          type: "POST",
          url: "folders/"+url,
          data: params,
          dataType: "json",
          success: function(data){
            _data.otherNode.moveTo(node, _data.hitMode);
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
      }
      /*Renombrar carpeta*/
      function rename(node_data){
        var id = node_data.node.key;
        var name = node_data.input.val();
        var nameOrig = node_data.node.title;
        var params = {folder: {id: id, name: name}};
        $.ajax({
          type: "PATCH",
          url: "folders/"+id,
          data: params,
          dataType: "json",
          success: function(data){
            $(node_data.node.span).removeClass("pending");
            node_data.node.setTitle(node_data.node.title);
          },
          error: function(xhr, event, status) {
            var errors = jQuery.parseJSON(xhr.responseText);
            //showError(eldoc.container.error, errors);
            $(node_data.node.span).removeClass("pending");
            node_data.node.setTitle(nameOrig);
            console.log(errors);
            return false;
          }
        });
      }
    }
  }

});
  
