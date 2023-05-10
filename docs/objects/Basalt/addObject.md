## addObject

### Description

The `basalt.addObject` method allows you to add new custom objects (elements) to the Basalt framework. This enables extending the framework with additional functionality tailored to specific needs. It's important to note that this method must be called before `basalt.autoUpdate` and can only be used during the initialization phase, not during runtime.

### Parameters

1. `string` The path to the Lua file or folder containing the custom object(s).

### Usage

* Loads a custom objects folder:

```lua
local basalt = require("basalt")

-- Add the custom object(s):
basalt.addObject("objects")

-- Rest of the code

basalt.autoUpdate()
```
