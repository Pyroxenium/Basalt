## clear
Removes all items.

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default menubar with 3 entries and removes them immediatley. Which makes no sense.
```lua
local main = basalt.createFrame()
local aMenubar = main:addMenubar()
  :addItem("1. Entry")
  :addItem("2. Entry",colors.yellow)
  :addItem("3. Entry",colors.yellow,colors.green)
aMenubar:clear()
```
