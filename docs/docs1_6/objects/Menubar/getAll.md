## getAll
Returns all items as table

#### Returns:
1. `table` All items

#### Usage:
* Creates a default menubar with 3 entries and prints a table.
```lua
local main = basalt.createFrame()
local aMenubar = main:addMenubar()
    :addItem("1. Entry")
    :addItem("2. Entry",colors.yellow)
    :addItem("3. Entry",colors.yellow,colors.green)
basalt.debug(aMenubar:getAll())
```