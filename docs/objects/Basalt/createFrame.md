# Basalt

## createFrame

Creates a new base-frame, you can have as many base-frames as you want, but only 1 can be active (visible) at the same time.
You can always switch between your base frames.

Only the currently active base-frame listens to incoming events (except for some events like time-events and peripheral-events)

### Parameters

1. `string` id - optional (if you dont set a id it will automatically create a uuid for you)

### Returns

1. `frame` object

### Usage

* How to use multiple base frames:

```lua
local main1 = basalt.createFrame() -- Visible base frame on program start
local main2 = basalt.createFrame()
local main3 = basalt.createFrame()
main1:addButton()
    :setPosition(2,2)
    :setText("Switch")
    :onClick(function()
        main2:show() -- this function automatically "hides" the first one and shows the second one
    end)
main2:addLabel()
    :setText("We are currently on main2")
basalt.autoUpdate()
```
