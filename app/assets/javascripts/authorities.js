jQuery(document).ready(function() {
  if ($("#ctrllr-authorities").length > 0){
    if ($("#authorities-index").length > 0){
      var table_id = "#authorities-index-table";
      var remote_documents = "#remote_documents";
      var table_documents_id = "#authorities-documents";
      var table = $(table_id).dataTable({
        "processing": true,
        "serverSide": true,
        "ajax": $('#authorities-index-table').data('source'),
        "pagingType": "simple",
        columnDefs: [ 
                      {"targets": [ 0, 1 ], "visible": false, "searchable": false},
                      // { orderable: false, targets: [2 , 3] }
        ],

        language: {
            url: "/datatables/spanish.txt",
        }
      });
      $(table_id + ' tbody').on( 'click', 'tr', function () {
        if ( $(this).hasClass('selected') ) {
            $(this).removeClass('selected');
            clearDocuments();
        }
        else {
            table.$('tr.selected').removeClass('selected');
            $(this).addClass('selected');
            var aPos = table.fnGetPosition(this);
            var aData = table.dataTable().fnGetData(aPos)
            clearDocuments();
            showDocuments(aData[0], aData[1]);
        }
      });

      /*Traer mediante ajax el listado de documents para la [dependencia, cargo]*/
      function showDocuments(dependency_id, employment_id){
        console.log("Dependencia: ",dependency_id,"Cargo: ", employment_id);
        $.ajax({
            type: "GET",
            url: "authorities/documents",
            data: {dependency_id: dependency_id, employment_id: employment_id},
            dataType: "html",
            success: function(data){
              removeError(remote_documents);
              $(remote_documents).html(data);
              fire_datatableDocument();
              return true;
            },
            error: function(xhr, event, status) {
              var errors = jQuery.parseJSON(xhr.responseText);
              showError(errors, remote_documents);
              return false;
            }
        });
      }
      function clearDocuments(){
        $(remote_documents).html("");
      }
      function fire_datatableDocument(){
        var datatable_document = $(table_documents_id).dataTable({
          "processing": true,
          "serverSide": true,
          "ajax": $(table_documents_id).data('source'),
          "pagingType": "simple",
          columnDefs: [ 
                         {"targets": [ 6 ], "searchable": false, orderable: false},
                         // { orderable: false, targets: [2 , 3] }
          ],
          fnInitComplete: function(oSettings, json){
            $("thead th").each( function (i) {
                $('select,input', this).change( function () {
                  datatable_document.fnFilter($(this).val(),i);
                 });
            });
            setTimeout(function(){
              $("input[type='search']").focus();
              $("input[type='search']").addClass('mousetrap');
            }, 0);
          },
          language: {
              url: "/datatables/spanish.txt",
          }
        });
        
        $("#emission_date").daterangepicker(
          {
            format: 'DD-MM-YYYY',
            startDate: moment().subtract(29, 'days'),
            endDate: moment(),
            // dateLimit: { days: 60 },
            showDropdowns: false,
            showWeekNumbers: false,
            timePicker: false,
            // timePickerIncrement: 1,
            // timePicker12Hour: true,
            ranges: {
               'Hoy': [moment(), moment()],
               'Ayer': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
               'Últimos 7 Días': [moment().subtract(6, 'days'), moment()],
               'Últimos 30 Días': [moment().subtract(29, 'days'), moment()],
               'Este mes': [moment().startOf('month'), moment().endOf('month')],
               'Último mes': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
            },
            opens: 'left',
            drops: 'down',
            buttonClasses: ['btn', 'btn-sm'],
            applyClass: 'btn-primary',
            cancelClass: 'btn-default',
            separator: ' a ',
            locale: {
                applyLabel: 'Aceptar',
                cancelLabel: 'Cancelar',
                fromLabel: 'Desde',
                toLabel: 'Hasta',
                customRangeLabel: 'Calendario',
                daysOfWeek: ['Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sa','Do'],
                monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
                firstDay: 1
            }
        },
          // {
          //   format: 'DD-MM-YYYY',
          //   locale: {
          //       monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
          //           'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
          //       daysOfWeek: ['Do', 'Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sa']
          //   },
          // },
          function(start, end, label) {
            $("#range_date").val(start.format('YYYY-MM-DD') + ' - ' + end.format('YYYY-MM-DD'));
            $("#range_date").trigger("change");
          }
        );


        $("#emission_date").on("change", function(){
          $("#range_date").val($("#emission_date").val());
        });
      }
    }
  }
});
