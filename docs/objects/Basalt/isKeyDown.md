# Basalt

## isKeyDown

Checks if the user is currently holding a key

### Parameters

1. `number` key code (use the [keys table](https://tweaked.cc/module/keys.html) for that)

### Returns

1. `boolean` true or false

### Usage

* Shows a debug message with true or false if the left ctrl key is down, as soon as you click on the button.

```lua
local main = basalt.createFrame()
local aButton = mainFrame:addButton()
    :setPosition(2,2)
    :setText("Check Ctrl")
    :onClick(function() 
        basalt.debug(basalt.isKeyDown(keys.leftCtrl))
    end)
basalt.autoUpdate()
```
