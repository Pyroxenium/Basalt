## selectItem
selects a item in the menubar (same as a player would click on a item)

#### Parameters: 
1. `number` The index which should get selected

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default menubar with 3 entries and selects the second entry.
```lua
local main = basalt.createFrame()
local aMenubar = main:addMenubar()
    :addItem("1. Entry")
    :addItem("2. Entry",colors.yellow)
    :addItem("3. Entry",colors.yellow,colors.green)
    :selectItem(2)
```