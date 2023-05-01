## getItem
Returns a item by index

#### Parameters: 
1. `number` The index which should be returned

#### Returns:
1. `table` The item table example: {text="1. Entry", bgCol=colors.black, fgCol=colors.white}

#### Usage:
* Creates a default menubar with 3 entries and edits the second one.
```lua
local main = basalt.createFrame()
local aMenubar = main:addMeubar()
    :addItem("1. Entry")
    :addItem("2. Entry",colors.yellow)
    :addItem("3. Entry",colors.yellow,colors.green)
basalt.debug(aMenubar:getItem(2).text)
```