## onDrag

### Description

`onDrag(self, event, button, x, y, xOffset, yOffset)`

The onDrag event is triggered when an object is being dragged with the mouse.

### Returns

1. `object` The object in use

### Usage

* Add an onDrag event to an object:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local button = main:addButton()
  :setPosition(3,3)
  :setSize(12,3)
  :setText("Drag")

function buttonOnDrag(event, button, x, y)
  basalt.debug("Button dragged at position: " .. x .. ", " .. y)
end
button:onDrag(buttonOnDrag)
```

* You can also change the frame's offset, by dragging around:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
    :onDrag(function(self, button, x, y, xOffset, yOffset)
      self:setOffset(-xOffset, -yOffset, true)
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

* Here is a example how to resize a frame by dragging a button around:

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
