## enable

### Description

Disables the object's event listeners

If the object is enabled, it will listen to incoming events. Disabling it will stop listening to events.

### Returns

1. `object` The object in use

### Usage

* Creates a default button and disables it, then re-enables it.

```lua
local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setText("Disabled Button")
aButton:disable()
```
