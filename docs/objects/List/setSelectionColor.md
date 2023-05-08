## setSelectionColor

### Description

Sets the background and the foreground of the item which is currently selected.

### Parameters

1. `number|color` The background color which should be used
2. `number|color` The text color which should be used

### Returns

1. `object` The object in use

### Usage

* Creates a default list with 4 entries and sets the selection background color to green and text color to red.

```lua
local mainFrame = basalt.createFrame()
local aList = mainFrame:addList()
aList:addItem("1. Entry")
aList:addItem("2. Entry",colors.yellow)
aList:addItem("3. Entry",colors.yellow,colors.green)
aList:addItem("4. Entry")
aList:setSelectionColor(colors.green, colors.red)
```

```xml
<list selectionBG="green" selectionFG="red">
  <item><text>1. Entry</text></item>
  <item><text>2. Entry</text><bg>yellow</bg></item>
  <item><text>2. Entry</text><bg>yellow</bg><fg>green</fg></item>
</list>
```
