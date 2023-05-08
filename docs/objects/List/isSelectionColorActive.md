## isSelectionColorActive

### Description

Checks if the selection color is active or not.

### Returns

1. `boolean` true if selection color is active, false otherwise.

### Usage

* Creates a default list with 4 entries, sets the selection colors, and then checks if the selection color is active.

```lua
local mainFrame = basalt.createFrame()
local aList = mainFrame:addList()
aList:addItem("1. Entry")
aList:addItem("2. Entry",colors.yellow)
aList:addItem("3. Entry",colors.yellow,colors.green)
aList:addItem("4. Entry")
aList:setSelectionColor(colors.green, colors.red)

local isActive = aList:isSelectionColorActive()
basalt.debug(isActive)
```
