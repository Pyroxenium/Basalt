## setText
Sets the displayed button text
#### Parameters: 
1. `string` the text the button should show

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a button with "Click me!" as text.
```lua
local mainFrame = basalt.createFrame()
local button = mainFrame:addButton():setText("Click me!")
```
```xml
<button text="Click me!" />
```