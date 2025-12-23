//%attributes = {}
#DECLARE($worker : 4D:C1709.SystemWorker; $params : Object)

var $text : Text
$text:=$worker.response
$file:=$params.context