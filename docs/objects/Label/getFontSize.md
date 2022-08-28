## getFontSize
Returns the current font size

#### Returns:
1. `number` font size

#### Usage:
* Creates a default label, sets the text to "Basalt!" and its font size to 2. Also prints the current fontsize.
```lua
local mainFrame = basalt.createFrame()
local aLabel = mainFrame:addLabel():setText("Basalt!"):setFontSize(2)
basalt.debug(aLabel:getFontSize())
```