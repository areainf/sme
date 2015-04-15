$(document).ready( function() {
  if($("#ctrllr-folders").length >0 ){
    if($("#folders-index").length >0 ){
      var parent_path = ["#parent_path", "#delete_parent_path"];
      var parent_id = ["#parent_id", "#delete_parent_id"];

      $("#tree").fancytree({
        lazy: true,
        extensions: ["dnd", "edit"],
        expanded: true,
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
            for (var i = 0; i < parent_id.length; i++)
              $(parent_id[i]).val(data.node.key); 
            var parents = data.node.getParentList();
            var p = "";
            for(var i = 0; i < parents.length; i++){
              if(p.length > 0) p +="/";
              p += parents[i].title;
            }
            if(p.length > 0) p +="/";
            p += data.node.title;

            for (var i = 0; i < parent_path.length; i++)
              $(parent_path[i]).html(p);
          }
        },
        dblclick: function(event, data) {
          if(!data.node.folder){
            //$("#documents-dialog_show").modal('show');
             $("#modal-show-document").modal('show');
            showDocument(data.node.key, "#document-content");
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
            if (data.node.folder && data.node.key != "")
              return true;
            return false;
          },
          edit: function(event, data){
            // Editor was opened (available as data.input)
          },
          beforeClose: function(event, data){
            // Return false to prevent cancel/save (data.input is available)
            return data.node.folder;
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
        },
      });
      $("#folders-index #new_folder").on("submit",function(evt){
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
                $("#folders-index #new_folder #folder_name").val("");
                $("#folders-index #new_folder #folder_description").val("");
                return false;
              },
              error: function(xhr, event, status) {
                var errors = jQuery.parseJSON(xhr.responseText);
                //showError(eldoc.container.error, errors);
                showError(errors);
                console.log(errors);
                return false;
              }
            });
            return false;
      });
      
      /*
      ELIMINAR  UNA CARPETA 
      */
      $("#btn-remove-folder").on("click", function(evt){
        var id = $("#delete_parent_id").val();
        if(id && confirm("Confirma que desea eliminar la Carpeta seleccionada?")){
          var tree = $("#tree").fancytree("getTree");
          var active_node = tree.getActiveNode();
          $.ajax({
            type: "DELETE",
            url: "folders/"+active_node.key,
            dataType: "json",
            success: function(data){
              active_node.remove();
            },
            error: function(xhr, event, status) {
              var errors = jQuery.parseJSON(xhr.responseText);
              //showError(eldoc.container.error, errors);
              showError(errors);
              console.log(errors);
              return false;
            }
          });
        }
      });

      /*Mover carpeta y documento desde hasta*/
      function move(_data, node){
        //ok = mover_document(data.otherNode.key, node.key);
                //data.otherNode.moveTo(node, data.hitMode);
        var params = {id_from: _data.otherNode.key, id_to: node.key};
        var url = "documents/move";
        if(_data.otherNode.folder)
          url = "folders/move";
        $.ajax({
          type: "POST",
          url: url,
          data: params,
          dataType: "json",
          success: function(data){
            _data.otherNode.moveTo(node, _data.hitMode);
            return false;
          },
          error: function(xhr, event, status) {
            var errors = jQuery.parseJSON(xhr.responseText);
            //showError(eldoc.container.error, errors);
            showError(errors);
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
            showError(errors);
            return false;
          }
        });
      }

      /*Traer mediante ajax el show de document*/
      function showDocument(id, container){
        $.ajax({
            type: "GET",
            url: "documents/"+id,
            dataType: "html",
            success: function(data){
              $(container).html(data);
              return true;
            },
            error: function(xhr, event, status) {
              var errors = jQuery.parseJSON(xhr.responseText);
              showError(errors, container);
              return false;
            }
        });
      }
    }
  }

});
  
