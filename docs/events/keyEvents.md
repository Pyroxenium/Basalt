Here we will talk about keyboard events and how you can manipulate them. There are 2 possible key events you can add to almost every visual object.

# onKey
`onKey(self, event, key)`<br>
The computercraft event which triggers this method is `key`.
Any visual object can register onKey events.

Here is a example on how to add a onKey event to your frame:

```lua
local basalt = require("Basalt")

local mainFrame = basalt.createFrame("myMainFrame"):show()
local subFrame = mainFrame:addFrame("subFrame"):setPosition(3,3):setSize(18,6):setBar("Sub Frame",colors.black):showBar():show()

function openSubFrame()
  subFrame:show()
end
mainFrame:onKey(openSubFrame)
```

# onKeyUp
`onKeyUp(self, event, key)`<br>
The computercraft event which triggers this method is `key_up`.
Any visual object can register onKeyUp events.

Here is a example on how to add a onKeyUp event to your frame:

```lua
local basalt = require("Basalt")

local mainFrame = basalt.createFrame("myMainFrame"):show()
local subFrame = mainFrame:addFrame("subFrame"):setPosition(3,3):setSize(18,6):setBar("Sub Frame",colors.black):showBar():show()

function openSubFrame()
  subFrame:show()
end
mainFrame:onKeyUp(openSubFrame)
```
