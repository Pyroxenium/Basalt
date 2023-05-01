# Object

## getAnchorPosition

Converts the x and y coordinates into the anchor coordinates of the object

### Parameters

1. `number|nil` x
2. `number|nil` y, if nothing it uses the object's x, y

#### Returns

1. `number` x
2. `number` y

#### Usage

* Prints the anchor position to the debug console

```lua
local mainFrame = basalt.createFrame():setSize(15,15)
local aButton = mainFrame:addButton()
        :setAnchor("bottomRight")
        :setSize(8,1)
        :setPosition(1,1)
basalt.debug(aButton:getAnchorPosition()) -- returns 7,14 (framesize - own size) instead of 1,1
```
