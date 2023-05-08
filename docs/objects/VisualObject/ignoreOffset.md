## ignoreOffset

### Description

Sets whether the object should ignore the offset of its parent frame. If set to `true`, the object's position will be absolute. By default, this value is set to `false`.

### Parameters

1. `boolean` ignore offset

### Returns

1. `object` The object in use

### Usage

* Creates a frame with an offset and a button that ignores the offset

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame():setOffset(5, 5)
local aButton = mainFrame:addButton():setSize(8, 1):setPosition(2, 2):ignoreOffset(true)

-- The button will be displayed at position (2,2) on the screen, 
-- ignoring the frame's offset of (5,5)
```

```xml
<button x="2" y="2" ignoreOffset="true" />
```
