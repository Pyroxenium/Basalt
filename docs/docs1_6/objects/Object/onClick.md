# onClick

`onClick(self, event, button, x, y)`

The computercraft event which triggers this method is `mouse_click` and `monitor_touch`.

Here is a example on how to add a onClick event to your button:

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

Here is also a example on how you could create double clicks:

```lua
local basalt = require("basalt")
local doubleClickMaxTime = 0.25 -- in seconds

local main = basalt.createFrame()
local button = main:addButton()

local function createDoubleClick(btn, func) -- here we create a function where we can pass buttons (or other object if you'd like to) and a function which will get called by double clicking.
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

createDoubleClick(button, debugSomething) -- this is how you will create a double click.

basalt.autoUpdate()
```
