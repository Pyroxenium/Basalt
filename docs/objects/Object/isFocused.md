# Object

## isFocused

Returns if the object is currently the focused object of the parent frame

### Returns

1. `boolean` Whether the object is focused

#### Usage

* Prints whether the button is focused to the debug console

```lua
local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton()
basalt.debug(aButton:isFocused()) -- shows true or false as a debug message
```
