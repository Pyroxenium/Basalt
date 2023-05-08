## remove

### Description

Removes the object from its parent

The object will no longer be visible and will not receive any events. Note that this does not destroy the object, and it can be re-added to another parent later if needed.

### Returns

1. `object` The object in use

### Usage

```lua
local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setText("My Button")
aButton:remove()
```
