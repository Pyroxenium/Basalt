## setOffset

### Description

Sets the frame's offset, this offset is beeing used to move all children object's by the offset's position

### Parameters

1. `number` x position
2. `number` y position

### Returns

1. `object` The object in use

### Usage

* Sets the baseframes offset by y5.

```lua
local main = basalt.createFrame()
local button = mainFrame:addButton()

main:setOffset(0, 5)
```
