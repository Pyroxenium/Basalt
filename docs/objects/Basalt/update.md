## update

Calls the draw and event handler once - this gives more flexibility about which events basalt should process. For example you could filter the terminate event.
Which means you have to pass the events into basalt.update.

### Parameters

1. `string` The event to be received
2. `...` Additional event variables to capture

### Usage

* Creates and starts a custom update cycle

```lua
local mainFrame = basalt.createFrame()
mainFrame:addButton():setPosition(2,2)
while true do
    local ev = table.pack(os.pullEventRaw())
    basalt.update(table.unpack(ev))
end
```
