property onData : 4D:C1709.Function
property onResponse : 4D:C1709.Function
property onError : 4D:C1709.Function
property onTerminate : 4D:C1709.Function

Class extends _CLI

Class constructor($class : 4D:C1709.Class)
	
	var $controller : 4D:C1709.Class
	var $superclass : 4D:C1709.Class
	$superclass:=$class.superclass
	$controller:=cs:C1710._curl_Controller
	
	While ($superclass#Null:C1517)
		If ($superclass.name=$controller.new)
			$controller:=$class
			break
		End if 
		$superclass:=$superclass.superclass
	End while 
	
	Super:C1705("curl"; $controller)
	
Function get worker() : 4D:C1709.SystemWorker
	
	return This:C1470.controller.worker
	
Function terminate()
	
	This:C1470.controller.terminate()
	
Function get controller : cs:C1710._curl_Controller
	
	return This:C1470._controller
	
Function version() : Object
	
	$command:=This:C1470.escape(This:C1470.executablePath)
	$command+=" --version"
	
	This:C1470.controller.execute($command)
	This:C1470.worker.wait()
	
	var $stdOut : Text
	$stdOut:=This:C1470.controller.stdOut
	
	var $lines : Collection
	$lines:=Split string:C1554($stdOut; This:C1470.EOL; ck ignore null or empty:K85:5)
	
	var $version : Object
	$version:={releaseDate: !00-00-00!; protocols: []; features: []; version: ""; platform: []; modules: []}
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	var $line : Text
	For each ($line; $lines)
		Case of 
			: (Match regex:C1019("Release-Date:\\s(\\d{4})-(\\d{2})-(\\d{2})"; $line; 1; $pos; $len))
				$yyyy:=Num:C11(Substring:C12($line; $pos{1}; $len{1}))
				$mm:=Num:C11(Substring:C12($line; $pos{2}; $len{2}))
				$dd:=Num:C11(Substring:C12($line; $pos{3}; $len{3}))
				$version.releaseDate:=Add to date:C393(!00-00-00!; $yyyy; $mm; $dd)
			: (Match regex:C1019("Protocols:\\s(.+)"; $line; 1; $pos; $len))
				$version.protocols:=Split string:C1554(Substring:C12($line; $pos{1}; $len{1}); " ")
			: (Match regex:C1019("Features:\\s(.+)"; $line; 1; $pos; $len))
				$version.features:=Split string:C1554(Substring:C12($line; $pos{1}; $len{1}); " ")
			: (Match regex:C1019("curl\\s([0-9.]+)\\s\\((.+)\\)\\s(.+)"; $line; 1; $pos; $len))
				$version.version:=Substring:C12($line; $pos{1}; $len{1})
				$version.platform:=Substring:C12($line; $pos{2}; $len{2})
				$version.modules:=Split string:C1554(Substring:C12($line; $pos{3}; $len{3}); " ")
		End case 
	End for each 
	
	return $version
	
Function execute($option : Variant; $events : Object) : Collection
	
	var $onResponse; $onData; $onTerminate; $onError : 4D:C1709.Function
	
	var $stdOut; $isStream; $isAsync : Boolean
	var $options : Collection
	var $results : Collection
	$results:=[]
	
	Case of 
		: (Value type:C1509($option)=Is object:K8:27)
			$options:=[$option]
		: (Value type:C1509($option)=Is collection:K8:32)
			$options:=$option
		Else 
			$options:=[]
	End case 
	
	var $commands : Collection
	$commands:=[]
	
	If ($events#Null:C1517)
		If (OB Instance of:C1731($events.onResponse; 4D:C1709.Function))
			$isAsync:=True:C214
			This:C1470.onResponse:=$events.onResponse
			This:C1470.controller.onResponse:=$events.onResponse
			If ($events.onData#Null:C1517)\
				 && (Value type:C1509($events.onData)=Is object:K8:27)\
				 && (OB Instance of:C1731($events.onData; 4D:C1709.Function))
				This:C1470.onData:=$events.onData
			End if 
			If ($events.onError#Null:C1517)\
				 && (Value type:C1509($events.onError)=Is object:K8:27)\
				 && (OB Instance of:C1731($events.onError; 4D:C1709.Function))
				This:C1470.onError:=$events.onError
			End if 
			If ($events.onTerminate#Null:C1517)\
				 && (Value type:C1509($events.onTerminate)=Is object:K8:27)\
				 && (OB Instance of:C1731($events.onTerminate; 4D:C1709.Function))
				This:C1470.onTerminate:=$events.onTerminate
			End if 
		End if 
	End if 
	
	For each ($option; $options)
		
		If ($option=Null:C1517) || (Value type:C1509($option)#Is collection:K8:32)
			continue
		End if 
		
		$command:=This:C1470.escape(This:C1470.executablePath)
		
		If ($isAsync)
			$command+=" -# "
		End if 
		
		$stdOut:=True:C214
		
		var $data; $file : Variant
		$data:=Null:C1517
		$file:=Null:C1517
		
		var $value : Variant
		For each ($value; $option)
			Case of 
				: (Value type:C1509($value)=Is text:K8:3)
					Case of 
						: ($value="-#")
							continue
						: ($value="-o") || ($value="--output")
							$stdOut:=False:C215
							$command+=" "+$value
							continue
						: ($value="@-") || ($value="-")
							$isStream:=True:C214
							$command+=" "+$value
							continue
						Else 
							$command+=" "+This:C1470.escape($value)
							continue
					End case 
					
				: (Value type:C1509($value)=Is real:K8:4)
					$command+=" "+String:C10($value)
					continue
				: (Value type:C1509($value)=Is boolean:K8:9)
					continue
				: (Value type:C1509($value)=Is null:K8:31)
					continue
				: (Value type:C1509($value)=Is object:K8:27)
					If ((OB Instance of:C1731($value; 4D:C1709.File)) || (OB Instance of:C1731($value; 4D:C1709.Folder)))
						$command+=" "+This:C1470.escape(This:C1470.expand($value).path)
					Else 
						If ($value.data#Null:C1517)
							$data:=$value.data
						End if 
						If ($value.file#Null:C1517)\
							 && ((Value type:C1509($value.file)=Is object:K8:27)\
							 && (OB Instance of:C1731($value.file; 4D:C1709.Blob))) || (Value type:C1509($value.file)=Is BLOB:K8:12) || (Value type:C1509($value.file)=Is text:K8:3)
							$file:=$value.file
							
						End if 
					End if 
				Else 
					//
			End case 
		End for each 
		
		SET TEXT TO PASTEBOARD:C523($command)
		
		var $worker : 4D:C1709.SystemWorker
		$worker:=This:C1470.controller.execute($command; $isStream ? $file : Null:C1517; $data).worker
		
		If (Not:C34($isAsync))
			$worker.wait()
		End if 
		
		If (Not:C34($isAsync))
			If ($stdOut)
				$results.push(This:C1470.controller.stdOut)
			Else 
				$results.push(Null:C1517)
			End if 
			This:C1470.controller.clear()
		End if 
		
	End for each 
	
	If (Not:C34($isAsync))
		return $results
	End if 