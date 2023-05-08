# Object

## getValue

Returns the currently saved value

### Returns

1. `any` Object's value

### Usage

* Prints the value of the checkbox to the debug console

```lua
local mainFrame = basalt.createFrame()
local aCheckbox = mainFrame:addCheckbox():setValue(true)
basalt.debug(aCheckbox:getValue()) -- returns true
```
