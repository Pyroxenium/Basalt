## getItem

### Description

Returns an item by index.

### Parameters

1. `number` The index of the item to be returned

#### Returns

1. `table` The item table, for example: {text="1. Entry", bgCol=colors.black, fgCol=colors.white, args={}}

### Usage

* Creates a default list with 3 entries and retrieves the second one.

```lua
local mainFrame = basalt.createFrame()
local aList = mainFrame:addList()
aList:addItem("1. Entry")
aList:addItem("2. Entry", colors.yellow)
aList:addItem("3. Entry", colors.yellow, colors.green)
basalt.debug(aList:getItem(2).text)
```
