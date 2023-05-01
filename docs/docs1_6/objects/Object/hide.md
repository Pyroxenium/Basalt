# Object

## hide

Hides the object

### Returns

1. `object` The object in use

#### Usage

* Hides a frame

```lua
local mainFrame = basalt.createFrame()
local button = mainFrame:addButton():setText("Close"):onClick(function() mainFrame:hide() end)
```

```xml
<button visible="false" />
```
