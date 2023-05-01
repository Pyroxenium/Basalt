## removeLine
Removes the line on index position

#### Parameteres:
1. `number` index
2. `string` text

#### Returns:
1. `object` The object in use

#### Usage:
* Removes a line
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aTextfield = mainFrame:addTextfield("myFirstTextfield"):show()
basalt.debug(aTextfield:removeLine())
```