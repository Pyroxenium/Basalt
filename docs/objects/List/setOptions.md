## setOptions

### Description

The `setOptions` method allows you to change the options of a List object. This method accepts a table containing the new options you want to set for the List object.

### Parameters

1. `table` A table containing the new options to set for the List object.

#### Returns

1. `object` The object in use

### Usage

* Creates a default list with 3 entries, then changes the background color and selection color of the list.

```lua
local mainFrame = basalt.createFrame()
local aList = mainFrame:addList()
aList:setOptions("Entry 1", "Entry 2", "Entry 3")

basalt.autoUpdate()
```

or

```lua
local mainFrame = basalt.createFrame()
local aList = mainFrame:addList()
aList:setOptions("Entry 1", {"Entry 2", colors.yellow}, {"Entry 3", colors.yellow, colors.green})

basalt.autoUpdate()
```
