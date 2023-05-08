## getAll
Returns all items as table

#### Returns:
1. `table` All items

#### Usage:
* Creates a default menubar with 3 entries and prints a table.
```lua
local mainFrame = basalt.createFrame()
local aDropdown = mainFrame:addDropdown()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
basalt.debug(aDropdown:getAll())
```