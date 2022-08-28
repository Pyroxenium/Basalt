## getLines
Returns all lines

#### Returns:
1. `table` lines

#### Usage:
* Prints all lines
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aTextfield = mainFrame:addTextfield("myFirstTextfield"):show()
basalt.debug(aTextfield:getLines())
```