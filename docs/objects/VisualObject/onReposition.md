## onReposition

### Description

`onReposition(self)`

The `onReposition` event is a custom event that gets triggered when the object is repositioned, such as when a dynamic value changes the object's position.

### Returns

1. `object` The object in use

### Usage

* Add an onReposition event to a button:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local aButton = main:addButton():setPosition(3,3)

local function onButtonReposition(self)
    self:setSize(self:getWidth() - self:getX(), 3)
end

aButton:onReposition(onButtonReposition)
```
