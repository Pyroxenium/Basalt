## setHorizontalAlign
Sets the horizontal align of the button text

#### Parameters: 
1. `string` the position as string ("left", "center", "right") - default is center.

#### Returns:
1. `object` The object in use

#### Usage:
* Sets the button's horizontal text align to right. 
```lua
local mainFrame = basalt.createFrame()
local button = mainFrame:addButton()
       :setText("Click me!")
       :setHorizontalAlign("right")
```
```xml
<button text="Click me!" horizontalAlign="right" />
```