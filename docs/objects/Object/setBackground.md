## setBackground
Changes the object background color, if you set the value to false the background wont be visible. For example you could see trough a frame.
#### Parameters: 
1. `number|color` Background color

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a frame, and sets its background color to `colors.gray`
```lua
local mainFrame = basalt.createFrame():setBackground(colors.gray)
```
```xml
<button bg="gray" />
```