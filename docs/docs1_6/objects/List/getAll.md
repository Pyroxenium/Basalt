## getAll
Returns all items as table

#### Returns:
1. `table` All items

#### Usage:
* Creates a default menubar with 3 entries and prints a table.
```lua
local mainFrame = basalt.createFrame()
local aList = mainFrame:addList()
aList:addItem("1. Entry")
aList:addItem("2. Entry",colors.yellow)
aList:addItem("3. Entry",colors.yellow,colors.green)
basalt.debug(aList:getAll())
```