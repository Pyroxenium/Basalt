## selectItem
selects a item in the dropdown (same as a player would click on a item)

#### Parameters: 
1. `number` The index which should get selected

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default dropdown with 3 entries and selects the second entry.
```lua
local mainFrame = basalt.createFrame()
local aDropdown = mainFrame:addDropdown()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:selectItem(2)
```