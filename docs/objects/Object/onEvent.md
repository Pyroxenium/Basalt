## onEvent

### Description

`onEvent(self, event, ...)`

The onEvent method is triggered for any other event that is not handled by the specific event methods. Some examples include: http_success, disk, modem_message, paste, peripheral, redstone, and more.

You can find a full list here: [CC:Tweaked](https://tweaked.cc/) (on the left sidebar)

### Returns

1. `object` The object in use

### Usage

* Add an onEvent event to your frame:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
main:onEvent(function(event, side, channel, replyChannel, message, distance)
    if(event == "modem_message") then
        basalt.debug("Message received: " .. tostring(message))
    end
end)
```
