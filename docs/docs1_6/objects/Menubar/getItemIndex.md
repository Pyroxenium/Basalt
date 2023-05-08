## getItemIndex
returns the item index of the currently selected item

#### Returns:
1. `number` The current index

#### Usage:
* Creates a default menubar with 3 entries selects the second entry and prints the currently selected index.
```lua
local main = basalt.createFrame()
local aMenubar = main:addMenubar()
    :addItem("1. Entry")
    :addItem("2. Entry",colors.yellow)
    :addItem("3. Entry",colors.yellow,colors.green)
    :selectItem(2)
basalt.debug(aMenubar:getItemIndex())
```