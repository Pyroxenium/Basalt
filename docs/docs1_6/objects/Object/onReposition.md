# Object - Event

## onReposition

`onReposition(self)`

This is a custom event which gets triggered as soon as the object gets repositioned (for example by dynamic value).

Here is a example on how to add a onReposition event to your button:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local aButton = main:addButton():setPosition(3,3)

local function onButtonReposition(self)
    self:setSize(self:getWidth() - self:getX(), 3)
end

aButton:onReposition(onButtonReposition)
```
