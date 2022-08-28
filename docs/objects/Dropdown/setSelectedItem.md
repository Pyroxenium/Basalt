## setSelectedItem
Sets the background and the foreground of the item which is currently selected

#### Parameters: 
1. `number|color` The background color which should be used
2. `number|color` The text color which should be used

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default dropdown with 4 entries and sets the selection background color to green.
```lua
local mainFrame = basalt.createFrame()
local aDropdown = mainFrame:addDropdown()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:addItem("4. Entry")
aDropdown:setSelectedItem(colors.green, colors.red)
```
```xml
<dropdown selectionBG="green" selectionFG="red">
  <item><text>1. Entry</text></item>
  <item><text>2. Entry</text><bg>yellow</bg></item>
  <item><text>2. Entry</text><bg>yellow</bg><fg>green</fg></item>
</dropdown>
```