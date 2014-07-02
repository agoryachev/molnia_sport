#= require dataTables/jquery.dataTables
# require dataTables/jquery.dataTables.bootstrap3
#= require dataTables/bootstrap/3/jquery.dataTables.bootstrap

dataTablesI18n =
  "sProcessing":   "Подождите..."
  "sLengthMenu":   "Показать _MENU_ записей"
  "sZeroRecords":  "Записи отсутствуют."
  "sInfo":         "Записи: с _START_ до _END_ из _TOTAL_"
  "sInfoEmpty":    "Записи с 0 до 0 из 0 записей"
  "sInfoFiltered": "(отфильтровано из _MAX_ записей)"
  "sInfoPostFix":  "",
  "sSearch":       "Поиск(от 3-х символов):"
  "sUrl":          ""
  "oPaginate":
    "sFirst": "Первая",   
    "sPrevious": "Предыдущая"
    "sNext": "Следующая"     
    "sLast": "Последняя"

defaultDTOptions =
  # sDom: "<'row-fluid'<'span5'l><'span5'f>r>t<'row-fluid'<'span5'i><'span8'p>>"
  sPaginationType: 'bootstrap'
  bProcessing: true
  bServerSide: true
  aaSorting: [
    [1, "desc"]
  ]
  oLanguage: dataTablesI18n
  bDestroy: true

$('#author-datatable').dataTable( $.extend(defaultDTOptions,{sAjaxSource: $('#author-datatable').data("source")}) )

# $.extend(defaultDTOptions,{sAjaxSource: $('#author-datatable').data("source")})