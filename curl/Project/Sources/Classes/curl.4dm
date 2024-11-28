Class extends _CLI

Class constructor($controller : 4D:C1709.Class)
	
	Super:C1705("curl"; $controller)
	
Function get worker() : 4D:C1709.SystemWorker
	
	return This:C1470._controller.worker
	
Function terminate()
	
	This:C1470.controller.terminate()
	
Function version() : Collection
	
	$command:=This:C1470.escape(This:C1470.executablePath)
	$command+=" --version"
	
	This:C1470.controller.execute($command)
	
	return Split string:C1554(This:C1470.worker.wait().response; This:C1470.EOL; ck ignore null or empty:K85:5)
	
Function perform($options : Collection) : cs:C1710.curl
	
	$command:=This:C1470.escape(This:C1470.executablePath)
	
	var $option : Variant
	For each ($option; $options)
		
		Case of 
			: (Value type:C1509($option)=Is object:K8:27)
				Case of 
					: (OB Instance of:C1731($option; 4D:C1709.File)) || (OB Instance of:C1731($option; 4D:C1709.Folder))
						$command+=" "+This:C1470.escape(This:C1470.expand($option).path)
				End case 
				
			: (Value type:C1509($option)=Is text:K8:3)
				Case of 
					: ($option="-@")
						$command+=" "+$option
					Else 
						$command+=" "+This:C1470.escape($option)
				End case 
				
			Else 
				$command+=" "+This:C1470.escape(String:C10($option))
		End case 
		
	End for each 
	
	This:C1470.controller.init().execute($command)
	
	return This:C1470