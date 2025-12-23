property stdOut : Text
property stdErr : Text

Class extends _CLI_Controller

Class constructor($CLI : cs:C1710._CLI)
	
	Super:C1705($CLI)
	
	This:C1470.clear()
	
Function clear() : cs:C1710._curl_Controller
	
	This:C1470.stdOut:=""
	This:C1470.stdErr:=""
	
	return This:C1470
	
Function onData($worker : 4D:C1709.SystemWorker; $params : Object)
	
	This:C1470.stdOut+=$params.data
	
Function onDataError($worker : 4D:C1709.SystemWorker; $params : Object)
	
	var $instance : cs:C1710.curl
	$instance:=This:C1470.instance
	
	If ($instance.onData#Null:C1517) && (OB Instance of:C1731($instance.onData; 4D:C1709.Function))
		
		This:C1470.stdErr+=$params.data
		
		var $stdErr : Text
		$stdErr:=This:C1470.stdErr
		
		ARRAY LONGINT:C221($pos; 0)
		ARRAY LONGINT:C221($len; 0)
		$i:=1
		While (Match regex:C1019("(#*)\\s*(\\d+(?:\\.\\d+?))%"; $stdErr; $i; $pos; $len))
			$bar:=Substring:C12($stdErr; $pos{1}; $len{1})
			$percentage:=Num:C11(Substring:C12($stdErr; $pos{2}; $len{2}))
			$i:=$pos{0}+$len{0}
			$context:={}
			$context.percentage:=$percentage
			$context.context:=This:C1470.SYSTEM_WORKER_CONTEXT[String:C10($worker.pid)]
			$instance.onData.call(This:C1470; $worker; $context)
		End while 
		This:C1470.stdErr:=Substring:C12($stdErr; $i)
	End if 
	
Function onResponse($worker : 4D:C1709.SystemWorker; $params : Object)
	
	var $instance : cs:C1710.curl
	$instance:=This:C1470.instance
	
	If (OB Instance of:C1731($instance.onResponse; 4D:C1709.Function))
		$instance.onResponse.call($worker; $params)
	End if 
	
Function onError($worker : 4D:C1709.SystemWorker; $params : Object)
	
	var $instance : cs:C1710.curl
	$instance:=This:C1470.instance
	
	If (OB Instance of:C1731($instance.onError; 4D:C1709.Function))
		$instance.onError.call($worker; $params)
	End if 
	
Function onTerminate($worker : 4D:C1709.SystemWorker; $params : Object)
	
	var $instance : cs:C1710.curl
	$instance:=This:C1470.instance
	
	If (OB Instance of:C1731($instance.onTerminate; 4D:C1709.Function))
		$instance.onTerminate.call($worker; $params)
	End if 