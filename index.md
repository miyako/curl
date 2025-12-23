---
layout: default
---

![version](https://img.shields.io/badge/version-20%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)
[![license](https://img.shields.io/github/license/miyako/curl)](LICENSE)
![downloads](https://img.shields.io/github/downloads/miyako/curl/total)

### Licensing

* The source code of this component is licensed under the [MIT license](https://github.com/miyako/curl/blob/master/LICENSE).
* See [curl.se](https://curl.se/docs/copyright.html) for the licensing of **curl**.
 
# Use curl from 4D

based on [stunnel/static-curl](https://github.com/stunnel/static-curl)

**Note for Windows 11**: unlike the `curl` that comes with Windows 11, this edition uses OpenSSL. some servers may require the `-k` option unless local certficates are properly configured (search "curl error 60").

## Usage

#### Get Version

```4d
var $version : Object
$version:=cs.curl.new().version()
```

there are 2 ways to invoke `.execute()`; synchronous and asynchronous.

**synchronous**: pass a single parameter and receive a collection of results in return.

you can pass a single object or a collection of objects in a single call.

**asynchronous**: pass a second formula parameter. an empty collection is returned at this point.

the formula should have the following signature:

```4d
#DECLARE($worker : 4D.SystemWorker; $params : Object)

var $text : Text
$text:=$worker.response
```
