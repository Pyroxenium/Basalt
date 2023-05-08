# Object

## getAbsolutePosition

Converts the relative coordinates into absolute coordinates

### Parameters

1. `number|nil` x
2. `number|nil` y

### Returns

1. `object` The object in use

### Usage

* Creates a frame and a button and prints the button's absolute position to the debug console

```lua
local mainFrame = basalt.createFrame():setPosition(3,3)
local aButton = mainFrame:addButton():setSize(8,1):setPosition(4,2)
basalt.debug(aButton:getAbsolutePosition()) -- returns 7,5 (frame coords + own coords) instead of 4,2
```
