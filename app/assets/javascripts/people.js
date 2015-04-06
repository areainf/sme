jQuery(document).ready(function() {
  if ($("#ctrllr-people").length > 0){
    if ($("#people-index").length > 0){
      var table = $('#people-index-table').dataTable({
        "processing": true,
        "serverSide": true,
        "ajax": $('#people-index-table').data('source'),
        "pagingType": "full_numbers",
        // optional, if you want full pagination controls.
        // Check dataTables documentation to learn more about
        // available options.
        columnDefs: [ { orderable: false, targets: [2] }],
        language: {
            url: "/datatables/spanish.txt",
        }
      });
    }
  }
});