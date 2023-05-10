## addPlugin

### Description

The `basalt.addPlugin` method allows you to add new custom plugins to the Basalt framework. This enables extending the framework with additional functionality tailored to specific needs. It's important to note that this method must be called before `basalt.autoUpdate` and can only be used during the initialization phase, not during runtime.

### Parameters

1. `string` The path to the Lua file or folder containing the plugin(s).

### Usage

* Loads a custom plugins folder:

```lua
local basalt = require("basalt")

-- Add the custom plugin(s):
basalt.addPlugin("plugin")

-- Rest of the code

basalt.autoUpdate()
```
