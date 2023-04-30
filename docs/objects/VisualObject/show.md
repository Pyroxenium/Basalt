## show

### Description

The `show` method makes the object visible if its parent frame is visible. If the parent frame is hidden, the object will not be displayed until the parent frame is shown.

### Returns

1. `object` The object in use

### Usage

* Show a button:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local button = mainFrame:addButton()
button:show()
```

In this example, a button is added to the mainFrame and the show method is called to make it visible.

```xml
<button visible="true" />
```

The show method allows you to control the visibility of the object within its parent frame.
