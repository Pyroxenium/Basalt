## enable

### Description

Enables the object's event listeners

If the object is disabled, it will stop listening to incoming events, this will reenable it.

### Returns

1. `object` The object in use

### Usage

* Creates a default button and disables it, then re-enables it.

```lua
local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setText("Enabled Button")
aButton:enable()
```
