## getItemCount

### Description

Returns the current item count.

#### Returns

1. `number` The item list count

### Usage

* Creates a default list with 3 entries and prints the current item count.

```lua
local mainFrame = basalt.createFrame()
local aList = mainFrame:addList()
aList:addItem("1. Entry")
aList:addItem("2. Entry", colors.yellow)
aList:addItem("3. Entry", colors.yellow, colors.green)
basalt.debug(aList:getItemCount())
```
