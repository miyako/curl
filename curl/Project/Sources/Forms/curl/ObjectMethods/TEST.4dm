If (FORM Event:C1606.code=On Clicked:K2:4)
	
	Form:C1466.setEnabled("STOP"; True:C214).setEnabled("TEST"; False:C215)
	
	$URL:="https://resources-download.4d.com/release/20.x/20.5/latest/mac/tool4d_arm64.tar.xz"
	
	$out:=Folder:C1567(fk desktop folder:K87:19).file("tool4d_arm64.tar.xz")
	
	Form:C1466.curl.perform([$URL; "-o"; $out; "-L"; "-#"])  //L:follow redirection
	
End if 