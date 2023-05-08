## getFrame

### Description

Returns a base frame by the given id.

### Parameters

1. `string` id

### Returns

1. `frame` The frame with the supplied id.

### Usage

* Creates, fetches and shows the "myFirstFrame" object

```lua
local main = basalt.createFrame("firstBaseFrame")
local main2 = basalt.createFrame("secondBaseFrame")
main:addButton()
    :setText("Show")
    :onClick(function()
        local frame2 = basalt.getFrame("secondBaseFrame")
        if(frame2 ~= nil)then
            frame2:show()
        end
    end)
basalt.autoUpdate()
```
