# Object - Event

## onDrag

`onDrag(self, event, button, x, y, xOffset, yOffset)`

The computercraft event which triggers this method is `mouse_drag`.

This is a example on how you would create a movable button:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local button = main:addButton()
  :setPosition(3,3)
  :setSize(12,3)
  :setText("Click")

function buttonOnDrag(self, button, x, y, xOffset, yOffset)
    self:setPosition(-xOffset, -yOffset, true) -- we need to reverse the offset and true means to add the offset instead of changing it.
end
button:onDrag(buttonOnDrag)

basalt.autoUpdate()
```

Another example on how you could change the frame's offset by dragging around.

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
    :onDrag(function(self, button, x, y, xOffset, yOffset)
      local xO, yO = self:getOffset()
      self:setOffset(xO-xOffset, yO-yOffset, true) -- we need to reverse the offset and true means to add the offset instead of changing it.
    end)

local button = main:addButton()
  :setPosition(3,3)
  :setSize(12,3)
  :setText("Click")
local button2 = main:addButton()
  :setPosition(16,3)
  :setSize(12,3)
  :setText("Click")

basalt.autoUpdate()
```

Also very interesting is a button where you are able to resize the frame just by dragging the button.

```lua
local basalt = require("basalt")

local main = basalt.createFrame()

local sub = main:addFrame():setSize(30,12):setMovable()
sub:addLabel():setText("Example Frame"):setSize("parent.w", 1):setBackground(colors.black):setForeground(colors.lightGray)

local dragButton = sub:addButton()
  :setAnchor("bottomRight")
  :setPosition(1,1)
  :setSize(1,1)
  :setText("/")
  :onDrag(function(self, button, x, y, xOffset, yOffset)
    sub:setSize(-xOffset, -yOffset, true)
  end)

basalt.autoUpdate()
```
