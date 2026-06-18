# cURL

**aknowledgements**: [stunnel/static-curl](https://github.com/stunnel/static-curl)

## Usage

#### Get Version

```4d
var $version : Object
$version:=cs.curl.curl.new().version()
```

### Basic Download

```4d
#DECLARE($params : Object)

If ($params=Null)
    
    CALL WORKER(1; Current method name; {})
    
Else 
        
    $URL:="https://resources-download.4d.com/release/20.x/20.5/latest/mac/tool4d_arm64.tar.xz"
    $out:=Folder(fk desktop folder).file("tool4d_arm64.tar.xz")
    
    $events:={}
    $events.onResponse:=Formula(ALERT([$2.context.fullName; "downloaded!"].join(" ")))
    $events.onData:=Formula(MESSAGE([$2.context.fullName; $2.percentage; "%"].join(" ")))
    $events.onTerminate:=Formula(ALERT("terminated!"))
    $events.onError:=Formula(ALERT("error!"))
    
    $tasks:=[]
    /*
        any element that is an object not a file or folder is considered a context object
        context object can have 2 properties: .data, .file
        .data is a variant that is passed to the callback 
        .file is used as the stdin (assuming you pass @ - or -)
        it can be 4D.File, 4D.Blob, Blob, or Text
    */
    $tasks.push([$URL; "-o"; $out; "-L"; "-k"; {data: $out; file: Null}])
    
    var $curl : cs.curl.curl
    $curl:=cs.curl.curl.new()
    $results:=$curl.execute($tasks; $events)
    
End if 
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
