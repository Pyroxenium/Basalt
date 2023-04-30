## getSelectionColor

### Description

Returns the background and text colors of the currently selected item.

### Returns

1. `number|color` The background color which should be used
2. `number|color` The text color which should be used

### Usage

* Creates a default list with 4 entries, sets the selection colors, and then retrieves and prints the selection colors.

```lua
local mainFrame = basalt.createFrame()
local aList = mainFrame:addList()
aList:addItem("1. Entry")
aList:addItem("2. Entry",colors.yellow)
aList:addItem("3. Entry",colors.yellow,colors.green)
aList:addItem("4. Entry")
aList:setSelectionColor(colors.green, colors.red)

local selectionBG, selectionFG = aList:getSelectionColor()
basalt.debug(selectionBG, selectionFG)
```
