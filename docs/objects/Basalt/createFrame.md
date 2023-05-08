## createFrame

### Description

Creates a new base frame, which is essentially a frame without a parent. You can have as many base frames as you want, but only one can be active (visible) at a time. You can always switch between your base frames.

Only the currently active base frame listens to incoming events (except for some events like time-events and peripheral-events).

### Parameters

1. `string` id - optional (if you don't set an ID, it will automatically create a UUID for you)

### Returns

1. `frame` object

### Usage

* How to use multiple base frames:

```lua
local main1 = basalt.createFrame() -- Visible base frame on program start
local main2 = basalt.createFrame()
local main3 = basalt.createFrame()
main1:addButton()
    :setPosition(2, 2)
    :setText("Switch")
    :onClick(function()
        main2:show() -- this function automatically "hides" the first one and shows the second one
    end)
main2:addLabel()
    :setText("We are currently on main2")
basalt.autoUpdate()
```
