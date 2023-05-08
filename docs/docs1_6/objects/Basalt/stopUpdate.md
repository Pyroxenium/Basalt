# Basalt

## stopUpdate / stop

Stops the automatic draw and event handler which got started by `basalt.autoUpdate()`.
`basalt.autoUpdate(false)` also does the same.

### Usage

* When the quit button is clicked, the button stops basalt's event listeners and draw handlers

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
