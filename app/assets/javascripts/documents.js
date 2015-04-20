
jQuery(document).ready(function() {
  if ($("#ctrllr-documents").length > 0){
    /*#######################################################
      ################  LISTAR DOCUMENTS          ###########
      #######################################################*/
    if ($("#documents-index").length > 0){
      var table = $('#documents-index-table').dataTable({
        "processing": true,
        "serverSide": true,
        "ajax": $('#documents-index-table').data('source'),
        "pagingType": "full_numbers",
        "order": [[ 4, "desc" ]],
         aoColumnDefs: [{ 'bSortable': false, 'aTargets': [  2, 3, 5, 6 ] }],
         fnInitComplete: function(oSettings, json){
            $("thead th").each( function (i) {
                $('select,input', this).change( function () {
                  table.fnFilter($(this).val(),i);
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
      $("#emission_date").daterangepicker({
          format: 'DD-MM-YYYY',
          locale: {
              monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
                  'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
              daysOfWeek: ['Do', 'Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sa']
          },
        },
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
});