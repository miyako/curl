![version](https://img.shields.io/badge/version-20%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)
[![license](https://img.shields.io/github/license/miyako/curl)](LICENSE)
![downloads](https://img.shields.io/github/downloads/miyako/curl/total)

### Licensing

* the source code of this component is licensed under the [MIT license](https://github.com/miyako/curl/blob/master/LICENSE).
* see [curl.se](https://curl.se/docs/copyright.html) for the licensing of **curl**.
 
# curl

## dependencies.json

 ```json
{
	"dependencies": {
		"curl": {
			"github": "miyako/curl",
			"version": "*"
		}
	}
}
```

based on [stunnel/static-curl](https://github.com/stunnel/static-curl)

**note for Windows 11**: unlike the `curl` that comes with Windows 11, this edition uses OpenSSL. some servers may require the `-k` option unless local certficates are properly configured (search "curl error 60").

## Usage - with UI

```4d
#DECLARE($params : Object)

If (Count parameters=0)
	
	CALL WORKER(1; Current method name; {})
	
Else 
	
	$form:=cs._curlForm.new()
	
End if 
```


## Usage - without UI

```4d
#DECLARE($params : Object)

If ($params=Null)
	
	/*
		async calls must be performed in a worker or form
	*/
	
	CALL WORKER(1; Current method name; {})
	
Else 
	
	var $curl : cs.curl
	$curl:=cs.curl.new(cs._curl_Controller)
	
	$URL:="https://resources-download.4d.com/release/20.x/20.5/latest/mac/tool4d_arm64.tar.xz"
	
	$out:=Folder(fk desktop folder).file("tool4d_arm64.tar.xz")
	
	$curl.perform([$URL; "-o"; $out; "-L"; "-#"])  //L:follow redirection
	
End if
```
