## getItemCount
Returns the current item count

#### Returns:
1. `number` The item list count

#### Usage:
* Creates a default menubar with 3 entries and prints the current item count.
```lua
local main = basalt.createFrame()
local aMenubar = main:addMenubar()
    :addItem("1. Entry")
    :addItem("2. Entry",colors.yellow)
    :addItem("3. Entry",colors.yellow,colors.green)
basalt.debug(aMenubar:getItemCount())
```