## setVerticalAlign
Sets the vertical align of the button text

#### Parameters: 
1. `string` the position as string ("top", "center", "bottom") - default is center.

#### Returns:
1. `object` The object in use

#### Usage:
* Sets the button's horizontal text align to right and the vertical text align to bottom. 
```lua
local mainFrame = basalt.createFrame()
local button = mainFrame:addButton()
       :setText("Click me!")
       :setHorizontalAlign("right")
       :setVerticalAlign("bottom")
```
```xml
<button text="Click me!" horizontalAlign="right" verticalAlign="bottom" />
```