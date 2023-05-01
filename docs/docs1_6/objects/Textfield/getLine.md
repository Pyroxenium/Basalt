## getLine
Returns the line on index position

#### Parameteres:
1. `number` index

#### Returns:
1. `string` line

#### Usage:
* Prints one line
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aTextfield = mainFrame:addTextfield("myFirstTextfield"):show()
basalt.debug(aTextfield:getLine(1))
```