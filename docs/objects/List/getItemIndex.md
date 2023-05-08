## getItemIndex

### Description

Returns the item index of the currently selected item.

#### Returns

1. `number` The current index

### Usage

* Creates a default list with 3 entries and removes the second one.

```lua
local mainFrame = basalt.createFrame()
local aList = mainFrame:addList()
aList:addItem("1. Entry")
aList:addItem("2. Entry", colors.yellow)
aList:addItem("3. Entry", colors.yellow, colors.green)
aList:selectItem(2)
basalt.debug(aList:getItemIndex())
```
