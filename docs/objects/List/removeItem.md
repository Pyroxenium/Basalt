## removeItem

### Description

Removes an item from the list.

### Parameters

1. `number` The index of the item to be removed

#### Returns

1. `object` The object in use

### Usage

* Creates a default list with 3 entries and removes the second one.

```lua
local mainFrame = basalt.createFrame()
local aList = mainFrame:addList()
aList:addItem("1. Entry")
aList:addItem("2. Entry", colors.yellow)
aList:addItem("3. Entry", colors.yellow, colors.green)
aList:removeItem(2)
```
