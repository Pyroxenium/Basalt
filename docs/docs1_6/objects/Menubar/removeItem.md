## removeItem
Removes a item from the menubar

#### Parameters: 
1. `number` The index which should get removed

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default menubar with 3 entries and removes the second one.
```lua
local main = basalt.createFrame()
local aMenubar = main:addMenubar()
    :addItem("1. Entry")
    :addItem("2. Entry",colors.yellow)
    :addItem("3. Entry",colors.yellow,colors.green)
    :removeItem(2)
```