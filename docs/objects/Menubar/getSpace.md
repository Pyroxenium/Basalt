## getSpace

### Description

Returns the space between the entries in the menubar.

### Returns

1. `number` The space between the entries

### Usage

* Creates a default menubar with 4 entries, sets the space between them to 3, and prints the current space.

```lua
local main = basalt.createFrame()
local aMenubar = main:addMenubar()
  :addItem("1. Entry")
  :addItem("2. Entry",colors.yellow)
  :addItem("3. Entry",colors.yellow,colors.green)
  :addItem("4. Entry")
  :setSpace(3)
basalt.debug(aMenubar:getSpace())
```
