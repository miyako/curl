Class extends _Form

Class constructor
	
	Super:C1705()
	
	$window:=Open form window:C675("curl")
	DIALOG:C40("curl"; This:C1470; *)
	
Function onLoad()
	
	Form:C1466.curl:=cs:C1710.curl.new(cs:C1710._curlUI_Controller)
	
	Form:C1466.setEnabled("STOP"; False:C215)
	
Function onUnload()
	
	Form:C1466.curl.terminate()
	
Function setEnabled($objectNames : Variant; $enabled : Boolean) : Object
	
	Case of 
		: (Value type:C1509($objectNames)=Is text:K8:3)
			$objectNames:=[$objectNames]
		: (Value type:C1509($objectNames)=Is collection:K8:32)
			//
		Else 
			$objectNames:=[]
	End case 
	
	For each ($objectName; $objectNames)
		OBJECT SET ENABLED:C1123(*; $objectName; $enabled)
	End for each 
	
	return Form:C1466