If (FORM Event:C1606.code=On Clicked:K2:4)
	
	Form:C1466.setEnabled("STOP"; False:C215).setEnabled("TEST"; True:C214)
	
	Form:C1466.curl.terminate()
	
End if 