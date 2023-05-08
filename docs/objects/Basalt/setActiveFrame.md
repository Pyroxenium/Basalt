## setActiveFrame

### Description

Sets the active base frame.

### Parameters

1. `frame` frame - The frame that should be the active base-frame.

### Usage

```lua
local basalt = require("basalt")

local main1 = basalt.createFrame("firstBaseFrame")
local main2 = basalt.createFrame("secondBaseFrame")

main1:addButton()
    :setText("Switch to main2")
    :onClick(function()
        basalt.setActiveFrame(main2)
    end)

main2:addButton()
    :setText("Switch to main1")
    :onClick(function()
        basalt.setActiveFrame(main1)
    end)

basalt.autoUpdate()
```
