## onEvent

### Description

`onEvent(self, event, ...)`

The onEvent method is triggered for any other event that is not handled by the specific event methods. Some examples include: http_success, disk, modem_message, paste, peripheral, redstone, and more.

You can find a full list here: [CC:Tweaked](https://tweaked.cc/) (on the left sidebar)

### Returns

1. `object` The object in use

### Usage

Add an onEvent event to your frame:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
main:onEvent(function(event, side, channel, replyChannel, message, distance)
    if(event == "modem_message") then
        basalt.debug("Message received: " .. tostring(message))
    end
end)
```

The parameters passed to this function are the same as those returned by `os.pullEvent()`. See [here](https://tweaked.cc/module/os.html#v:pullEvent) for more info.

Alternatively, you can add an onEvent event to an XML layout:

```xml
<onEvent>
    local eventType = event[2]
    
    if (eventType == "modem_message") then
        local message = event[6]
        basalt.debug("Message received: " .. message)
    end
</onEvent>
```

In this case, the event table indices correspond to:
* 1: The Object where this event is being handled
* 2, 3,...: the `os.pullEvent()` parameters
