# Object

## isVisible

Returns if the object is currently visible

### Returns

1. `boolean`

#### Usage

* Prints boolean visibility of object to debug console

```lua
local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setSize(5,8)
basalt.debug(aButton:isVisible()) -- returns true
```
