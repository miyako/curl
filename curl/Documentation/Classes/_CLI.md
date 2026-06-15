# _CLI
### Abstract base class for wrapping a platform-native CLI executable.

> _CLI.new (executableName : Text; controller : 4D.Class)

| Parameter | Type | | Description |
| --- | --- | --- | --- |
| executableName | Text | -> | Base name of the executable (without `.exe` on Windows) |
| controller | 4D.Class | -> | Controller class to attach (default: `cs.curl._CLI_Controller`) |

## Description

`_CLI` resolves the platform-specific path to a bundled executable and attaches a controller that manages the underlying `4D.SystemWorker`. It is extended by [`curl`](curl.md) and should not be instantiated directly.

### Resolution strategy

The constructor looks for the executable under `/RESOURCES/bin/{platform}/`. If found, the full path is stored and `chmod +x` is applied on macOS. If not found, the executable name alone is stored and resolution is delegated to `$PATH` at runtime.

Platform identifiers:

| Platform | Value |
| --- | --- |
| macOS | `macOS` |
| Windows (x64) | `Windows` |
| Windows (ARM) | `WindowsARM` |

ARM detection on Windows inspects `System info.processor` for known ARM processor identifiers: `apple`, `snapdragon`, `qualcomm`, `oryon`, `sq`, `ampere`, `altra`, `neoverse`, `graviton`, `cobalt`, `cortex`, `arm`.

### Properties (read-only)

| Property | Type | Description |
| --- | --- | --- |
| name | Text | Class name |
| EOL | Text | `\n` on macOS, `\r\n` on Windows |
| executableName | Text | Resolved executable file name |
| platform | Text | Platform string (see table above) |
| currentDirectory | 4D.Folder | Folder containing the executable |
| executablePath | Text | Full path (or bare name) of the executable |
| executableFile | 4D.File | `4D.File` reference to the executable |
| controller | cs.curl._CLI_Controller | Attached controller instance |

### Methods

#### escape (in : Text) → Text

Shell-escapes a string for the current platform.

| Parameter | Type | | Description |
| --- | --- | --- | --- |
| in | Text | -> | Raw string to escape |
| Result | Text | <- | Shell-safe string |

On macOS/zsh the method prefixes each shell metacharacter with `\`. On Windows/cmd.exe it wraps the string in double quotes when any metacharacter (`& | < > ( ) % ^ " space`) is present.

#### expand (in : Object) → Object

Re-creates a `4D.File` or `4D.Folder` from its platform path, ensuring correct normalization across platforms.

| Parameter | Type | | Description |
| --- | --- | --- | --- |
| in | Object | -> | A `4D.File` or `4D.Folder` |
| Result | Object | <- | New object of the same class constructed from the platform path |

#### quote (in : Text) → Text

Wraps a string in double quotes unconditionally.

| Parameter | Type | | Description |
| --- | --- | --- | --- |
| in | Text | -> | Input text |
| Result | Text | <- | `"input"` |

## See also

- [`_CLI_Controller`](_CLI_Controller.md) — manages `4D.SystemWorker` execution
- [`curl`](curl.md) — extends `_CLI` to wrap the `curl` executable
