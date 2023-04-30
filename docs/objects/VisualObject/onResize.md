## onResize

### Description

`onResize(self)`

The `onResize` event is a custom event that gets triggered when the parent frame is resized.

### Returns

1. `object` The object in use

### Usage

* Add an onResize event to a button:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local aButton = main:addButton():setPosition(3,3)

local function onButtonResize(self)
    local width = main:getWidth()
    self:setSize(width, 3)
end

aButton:onResize(onButtonResize)
```
