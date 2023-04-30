## stopUpdate / stop

### Description

This method stops the automatic draw and event handler that was started by  `basalt.autoUpdate()`.
`basalt.autoUpdate(false)` achieves the same result.

### Usage

* When the quit button is clicked, the button stops Basalt's event listeners and draw handlers.

```lua
local main = basalt.createFrame()
main:addButton()
    :setPosition(2,2)
    :setText("Stop Basalt!")
    :onClick(function()
        basalt.stopUpdate()
    end)
basalt.autoUpdate()
```
