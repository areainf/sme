jQuery(document).ready(function() {
  if ($("#ctrllr-employments").length > 0){
    if ($("#employments-index").length > 0){
      var table = $('#employments-index-table').dataTable({
        "processing": true,
        "serverSide": true,
        "ajax": $('#employments-index-table').data('source'),
        "pagingType": "full_numbers",
        // optional, if you want full pagination controls.
        // Check dataTables documentation to learn more about
        // available options.
        columnDefs: [ { orderable: false, targets: [1] }],
        language: {
            url: "/datatables/spanish.txt",
        }
      });
    }
  }
});