## setText
Sets the text which gets displayed.

#### Parameters: 
1. `string` The text which should be displayed

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default label with text "Some random text".
```lua
local mainFrame = basalt.createFrame()
local aLabel = mainFrame:addLabel():setText("Some random text")
```
```xml
<label text="Some random text" />
```