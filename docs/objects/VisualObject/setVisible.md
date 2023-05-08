## setVisible

### Description

The `setVisible` method allows you to control the visibility of an object directly by passing a boolean value (true for visible, false for hidden).

### Returns

1. `boolean` The visibility state of the object (true for visible, false for hidden)

### Usage

* Toggle visibility of a button:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local button = mainFrame:addButton():setText("Toggle")
local anotherButton = mainFrame:addButton():setText("Another Button")

button:onClick(function()
    local currentState = anotherButton:isVisible()
    anotherButton:setVisible(not currentState)
end)
```

In this example, a button is added to the mainFrame with the text "Toggle". When clicked, the setVisible method is called on anotherButton, toggling its visibility between hidden and visible states.
