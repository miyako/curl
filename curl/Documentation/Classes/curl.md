# curl
### Wraps the `curl` CLI to execute HTTP requests via `4D.SystemWorker`.

> curl.new (class : 4D.Class)

| Parameter | Type | | Description |
| --- | --- | --- | --- |
| class | 4D.Class | -> | Optional custom controller class; must extend `_curl_Controller` (default: `cs.curl._curl_Controller`) |

## Description

`cs.curl.curl` extends [`_CLI`](_CLI.md) and wraps the system `curl` executable. It provides `version()` to inspect the installed build and `execute()` to run one or more curl commands, with support for both synchronous and asynchronous operation.

If a class that does not extend `_curl_Controller` is passed, the constructor silently falls back to `cs.curl._curl_Controller`. Detection walks the full superclass chain.

### Properties

| Property | Type | Description |
| --- | --- | --- |
| onData | 4D.Function | Called by the controller on each parsed progress update (async mode only) |
| onResponse | 4D.Function | Called by the controller when a command completes |
| onError | 4D.Function | Called by the controller on worker error |
| onTerminate | 4D.Function | Called by the controller when the worker terminates |
| worker | 4D.SystemWorker | The currently active worker (read-only, from controller) |
| controller | cs.curl._curl_Controller | The attached controller instance (read-only) |

### Methods

#### version () → Object

Runs `curl --version` synchronously and parses the output into a structured object.

| Result property | Type | Description |
| --- | --- | --- |
| version | Text | curl version string (e.g. `"8.7.1"`) |
| releaseDate | Date | Release date |
| platform | Text | Build platform string |
| protocols | Collection | Supported protocol names |
| features | Collection | Enabled feature names |
| modules | Collection | Linked modules |

#### execute (option : Variant; events : Object) → Collection

Runs one or more curl commands built from an options collection, in sync or async mode.

| Parameter | Type | | Description |
| --- | --- | --- | --- |
| option | Object \| Collection | -> | A single options collection or a collection of options collections (see below) |
| events | Object | -> | Event callbacks; if `events.onResponse` is set the call is asynchronous |
| Result | Collection | <- | Collection of stdout strings (one per command), or `Null` in async mode |

**Sync mode** (no `events.onResponse`): each worker runs to completion before the next starts. `controller.stdOut` is collected into `$results` and `controller.clear()` is called after each command. The method returns a Collection of raw stdout strings, or `Null` entries where `-o` / `--output` was specified.

**Async mode** (`events.onResponse` present): workers are started without waiting. The method returns `Null` immediately. Progress updates are delivered to `events.onData` as percentage objects (see [`_curl_Controller`](_curl_Controller.md)). In async mode curl's `-#` progress-bar flag is prepended automatically.

**option element types** — each `option` is a flat collection where elements are interpreted by type:

| Element type | Behaviour |
| --- | --- |
| Text | Shell-escaped and appended as-is, except for the special values below |
| Real / Integer | Appended as a numeric string |
| Boolean / Null | Ignored |
| 4D.File / 4D.Folder | Platform path is shell-escaped and appended |
| Object with `.data` | Payload posted to worker stdin |
| Object with `.file` | Blob or Text posted to worker stdin (streaming mode) |

**Special text values:**

| Value | Effect |
| --- | --- |
| `"-#"` | Suppressed (added automatically in async mode) |
| `"-o"` / `"--output"` | Marks output as going to a file; `Null` is pushed to results instead of stdout |
| `"@-"` / `"-"` | Activates streaming mode; stdin payload is posted from `.file` |

### Examples

#### Synchronous GET

```4d
var $curl : cs.curl.curl
$curl:=cs.curl.curl.new(Null)

var $results : Collection
$results:=$curl.execute([\
    "https://example.com/api/data"; \
    "-H"; "Accept: application/json"]; \
    Null)

var $body : Text
$body:=$results[0]
```

#### Synchronous POST with data

```4d
$results:=$curl.execute([\
    "-X"; "POST"; \
    "https://example.com/api"; \
    "-H"; "Content-Type: application/json"; \
    {data: {key: "value"}}]; \
    Null)
```

#### Asynchronous download with progress

```4d
var $events : Object
$events:={}\

$events.onData:=Formula(\
    MESSAGE("Download: "+String($2.percentage; "##0.0")+"%"))

$events.onResponse:=Formula(\
    ALERT("Download complete"))

$curl.execute([\
    "https://example.com/large-file.zip"; \
    "-o"; Folder(fk desktop folder).file("large-file.zip")]; \
    $events)
```

#### Query curl version

```4d
var $curl : cs.curl.curl
$curl:=cs.curl.curl.new(Null)

var $v : Object
$v:=$curl.version()
// $v.version    -> "8.7.1"
// $v.protocols  -> ["dict","file","ftp",...]
// $v.features   -> ["alt-svc","AsynchDNS",...]
```

## See also

- [`_CLI`](_CLI.md) — parent class providing executable resolution and shell escaping
- [`_curl_Controller`](_curl_Controller.md) — default controller; handles progress parsing and event forwarding
- [`_CLI_Controller`](_CLI_Controller.md) — base controller providing the command queue
