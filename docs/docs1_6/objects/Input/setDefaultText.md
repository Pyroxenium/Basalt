## setDefaultText
Sets the default text. This will only be displayed if there is no input set by the user.

#### Parameters: 
1. `string` input type ("text", "password", "number")
2. `number|color` default background color - optional
3. `number|color` default text color - optional

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default input and sets the default text to "...".
```lua
local mainFrame = basalt.createFrame()
local aInput = mainFrame:addInput():setDefaultText("...")
```
```xml
<input default="..." />
```