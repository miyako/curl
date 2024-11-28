//%attributes = {}
#DECLARE($params : Object)

If ($params=Null:C1517)
	
/*
async calls must be performed in a worker or form
*/
	
	CALL WORKER:C1389(1; Current method name:C684; {})
	
Else 
	
	var $curl : cs:C1710.curl
	$curl:=cs:C1710.curl.new(cs:C1710._curl_Controller)
	
	$URL:="https://resources-download.4d.com/release/20.x/20.5/latest/mac/tool4d_arm64.tar.xz"
	
	$out:=Folder:C1567(fk desktop folder:K87:19).file("tool4d_arm64.tar.xz")
	
	$curl.perform([$URL; "-o"; $out; "-L"; "-#"; "-k"])  //L:follow redirection
	
End if 