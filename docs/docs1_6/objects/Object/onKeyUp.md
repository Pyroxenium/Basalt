# Object - Event

## onKeyUp

`onKeyUp(self, event, key)`

The computercraft event which triggers this method is `key_up`.

Here is a example on how to add a onKeyUp event to your frame:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local subFrame = main:addFrame()
  :setPosition(3,3)
  :setSize(18,6)

function openSubFrame(self, event, key)
  if(key==keys.c)then
    subFrame:show()
  end
end
main:onKeyUp(openSubFrame)
```
