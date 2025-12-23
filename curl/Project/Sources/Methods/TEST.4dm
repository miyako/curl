//%attributes = {}
#DECLARE($params : Object)

If ($params=Null:C1517)
	
	CALL WORKER:C1389(1; Current method name:C684; {})
	
Else 
	
	var $curl : cs:C1710.curl
	$curl:=cs:C1710.curl.new(cs:C1710._curl_Controller)
	
	$URL:="https://resources-download.4d.com/release/20.x/20.5/latest/mac/tool4d_arm64.tar.xz"
	$out:=Folder:C1567(fk desktop folder:K87:19).file("tool4d_arm64.tar.xz")
	
	$events:={}
	$events.onResponse:=Formula:C1597(ALERT:C41([$2.context.fullName; "downloaded!"].join(" ")))
	$events.onData:=Formula:C1597(MESSAGE:C88([$2.context.fullName; $2.percentage; "%"].join(" ")))
	$events.onTerminate:=Formula:C1597(ALERT:C41("terminated!"))
	$events.onError:=Formula:C1597(ALERT:C41("error!"))
	
	$tasks:=[]
/*
any element that is an object not a file or folder is considered a context object
context object can have 2 properties: .data, .file
.data is a variant that is passed to the callback 
.file is used as the stdin (assuming you pass @ - or -)
it can be 4D.File, 4D.Blob, Blob, or Text
*/
	$tasks.push([$URL; "-o"; $out; "-L"; "-k"; {data: $out; file: Null:C1517}])
	$results:=$curl.execute($tasks; $events)
	
End if 