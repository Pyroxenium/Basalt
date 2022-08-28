## setInputType
Changes the input type. default: text

#### Parameters: 
1. `string` input type ("text", "password", "number")

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default input and sets it to numbers only.
```lua
local mainFrame = basalt.createFrame()
local aInput = mainFrame:addInput():setInputType("number")
```
```xml
<input type="number" />
```