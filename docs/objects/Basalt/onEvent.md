# Basalt

## onEvent

This is the top-level method to intercept an event before sending it to the object event handlers. If you use return false, the event is not passed to the event handlers.

### Parameters

1. `function` The function which should be called

### Usage

```lua
local basalt = require("basalt")

basalt.onEvent(function(event)
    if(event=="terminate")then
        return false
    end
end)
```
