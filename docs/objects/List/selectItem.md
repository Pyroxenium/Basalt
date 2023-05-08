## selectItem

### Description

Selects an item in the list (same as a user would click on an item).

### Parameters

1. `number` The index of the item that should be selected

#### Returns

1. `object` The object in use

### Usage

* Creates a default list with 3 entries and selects the second entry

```lua
local mainFrame = basalt.createFrame()
local aList = mainFrame:addList()
aList:addItem("1. Entry")
aList:addItem("2. Entry", colors.yellow)
aList:addItem("3. Entry", colors.yellow, colors.green)
aList:selectItem(2)
```
