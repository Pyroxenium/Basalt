# Object - Event

## onResize

`onResize(self)`

This is a custom event which gets triggered as soon as the parent frame gets resized.

Here is a example on how to add a onResize event to your button:

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
