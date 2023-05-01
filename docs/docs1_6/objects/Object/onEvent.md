# Object - Event

## onEvent

`onEvent(self, event, ...)`

This event gets called on any other event. Some examples: http_success, disk, modem_message, paste, peripheral, redstone,...

You can find a full list here: [CC:Tweaked](https://tweaked.cc/) (on the left sidebar)

Here is a example on how to add a onEvent event to your frame:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
main:onEvent(function(event, side, channel, replyChannel, message, distance)
    if(event=="modem_message")then
        basalt.debug("Mesage received: "..tostring(message))
    end
end)
```
