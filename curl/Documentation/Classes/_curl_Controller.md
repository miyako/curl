# _curl_Controller
### Extends `_CLI_Controller` with stdout/stderr accumulation and curl progress-bar parsing.

> _curl_Controller.new (CLI : cs.curl._CLI)

| Parameter | Type | | Description |
| --- | --- | --- | --- |
| CLI | cs.curl._CLI | -> | The owning `_CLI` instance |

## Description

`_curl_Controller` is the default controller used by [`curl`](curl.md). It inherits all command-queue and worker-management behaviour from [`_CLI_Controller`](_CLI_Controller.md) and overrides the data and response event handlers to:

- Accumulate stdout into `stdOut` for synchronous callers.
- Parse curl's `--progress-bar` (`-#`) output from stderr and forward structured progress objects to `curl.onData`.
- Forward `onResponse`, `onError`, and `onTerminate` events to the corresponding callbacks on the owning `curl` instance.

### Properties

In addition to properties inherited from `_CLI_Controller`:

| Property | Type | Description |
| --- | --- | --- |
| stdOut | Text | Accumulated stdout text from the last command |
| stdErr | Text | Accumulated stderr text (consumed incrementally during progress parsing) |

### Methods

#### clear () → cs.curl._curl_Controller

Resets `stdOut` and `stdErr` to empty strings. Called automatically by the constructor and by `curl.execute` between successive synchronous commands.

| Result | Type | Description |
| --- | --- | --- |
| Result | cs.curl._curl_Controller | `This` — enables chaining |

### Overridden event callbacks

#### onData ($worker : 4D.SystemWorker; $params : Object)

Appends `$params.data` to `stdOut`.

#### onDataError ($worker : 4D.SystemWorker; $params : Object)

Handles curl's stderr stream. When `curl.onData` is set, appends incoming data to `stdErr` and scans it with a regex for curl progress-bar entries of the form `###…  nn.nn%`. For each match found, calls `curl.onData` with a context object:

| Property | Type | Description |
| --- | --- | --- |
| percentage | Real | Parsed progress percentage (0–100) |
| context | Object | Per-command context from `SYSTEM_WORKER_CONTEXT` keyed by worker PID |

Consumed characters are trimmed from `stdErr` after each scan pass, so partial lines are held until a complete match arrives.

When `curl.onData` is not set, stderr is silently discarded.

#### onResponse ($worker : 4D.SystemWorker; $params : Object)

Forwards to `curl.onResponse` if set.

#### onError ($worker : 4D.SystemWorker; $params : Object)

Forwards to `curl.onError` if set.

#### onTerminate ($worker : 4D.SystemWorker; $params : Object)

Forwards to `curl.onTerminate` if set.

## See also

- [`_CLI_Controller`](_CLI_Controller.md) — parent class
- [`curl`](curl.md) — sets `onData`, `onResponse`, `onError`, `onTerminate` which this controller forwards to
