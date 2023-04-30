## setTransparency

### Description

Enables or disables transparency for the object. This is useful for textures or custom drawings to skip spaces in color strings instead of using the standard background color. However, enabling transparency requires more processing power and is therefore disabled by default.

### Parameters

1. `boolean` Transparency state

### Returns

1. `object` The object in use

### Usage

* Creates a frame, and enables transparency

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame():setTransparency(true)
```

```xml
<frame transparency="true" />
```
