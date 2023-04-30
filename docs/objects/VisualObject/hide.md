## hide

### Description

The `hide` method makes the object invisible, but it remains part of the parent frame. This can be useful for creating toggleable UI elements or hiding objects that should only be displayed under certain conditions.

### Returns

1. `object` The object in use

#### Usage

* Hides a frame:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local button = mainFrame:addButton():setText("Close"):onClick(function(self) mainFrame:hide() end)
```

In this example, a button is added to the mainFrame with the text "Close". When clicked, the hide method is called on the mainFrame, making it invisible.

```xml
<button visible="false" />
```

The hide method allows you to control the visibility of the object within its parent frame.
