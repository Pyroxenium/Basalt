# Object - Event

## onChar

`onChar(self, event, char)`

The computercraft event which triggers this method is `char`.

The char event always happens after the key event (just like in cc:tweaked)

Here is a example on how to add a onChar event to your frame:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local subFrame = main:addFrame()
  :setPosition(3,3)
  :setSize(18,6)
  :hide()

function openSubFrame(self, event, char)
  if(char=="a")then
    subFrame:show()
  end
end
main:onChar(openSubFrame)
```
