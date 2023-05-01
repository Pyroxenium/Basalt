## setInputLimit
Sets a character limit to the input.

#### Parameters: 
1. `number` character limit

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default input and sets the character limit to 8.
```lua
local mainFrame = basalt.createFrame()
local aInput = mainFrame:addInput():setInputLimit(8)
```
```xml
<input limit="8" />
```