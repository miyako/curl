Class extends _CLI_Controller

property _stdOUt : Text
property _stdErr : Text
property percentage : Real

Class constructor($CLI : cs:C1710._CLI)
	
	Super:C1705($CLI)
	
	This:C1470.init()
	
Function init() : cs:C1710._curl_Controller
	
	This:C1470._stdOut:=""
	This:C1470._stdErr:=""
	This:C1470.percentage:=0
	
	return This:C1470
	
Function onData($worker : 4D:C1709.SystemWorker; $params : Object)
	
Function onDataError($worker : 4D:C1709.SystemWorker; $params : Object)
	
	If ($worker.dataType="text") && (($worker.encoding="utf-8"))
		
		This:C1470._stdErr+=$params.data
		
		ARRAY LONGINT:C221($pos; 0)
		ARRAY LONGINT:C221($len; 0)
		
		If (Match regex:C1019("(#*)\\s*(\\d+(?:\\.\\d+?))%"; This:C1470._stdErr; 1; $pos; $len))
			$bar:=Substring:C12(This:C1470._stdErr; $pos{1}; $len{1})
			This:C1470.percentage:=Num:C11(Substring:C12(This:C1470._stdErr; $pos{2}; $len{2}))
			This:C1470._stdErr:=Substring:C12(This:C1470._stdErr; $pos{0}+$len{0})
		End if 
	End if 
	
Function onResponse($worker : 4D:C1709.SystemWorker; $params : Object)
	
	This:C1470.instance.data:=$worker.response
	
Function onError($worker : 4D:C1709.SystemWorker; $params : Object)
	
Function onTerminate($worker : 4D:C1709.SystemWorker; $params : Object)
	