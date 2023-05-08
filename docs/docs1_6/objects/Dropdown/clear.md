## clear
Removes all items.

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default dropdown with 3 entries and removes them immediatley. Which makes no sense.
```lua
local mainFrame = basalt.createFrame()
local aDropdown = mainFrame:addDropdown()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:clear()
```