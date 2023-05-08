## onClick

### Description

`onClick(self, event, button, x, y)`

The onClick event is triggered when a mouse click or monitor touch occurs on the object.

### Returns

1. `object` The object in use

### Usage

* Add an onClick event to a button:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local button = main:addButton()
  :setPosition(3,3)
  :setSize(12,3)
  :setText("Click")

function buttonOnClick()
  basalt.debug("Button got clicked!")
end
button:onClick(buttonOnClick)
```

* Create double clicks:

```lua
local basalt = require("basalt")
local doubleClickMaxTime = 0.25 -- in seconds

local main = basalt.createFrame()
local button = main:addButton()

local function createDoubleClick(btn, func)
    local doubleClick = 0
    btn:onClick(function()
        if(os.epoch("local")-doubleClickMaxTime*1000<=doubleClick)then
            func()
        end
        doubleClick = os.epoch("local")
    end)
end

local function debugSomething()
    basalt.debug("hello")
end

createDoubleClick(button, debugSomething)

basalt.autoUpdate()
```
