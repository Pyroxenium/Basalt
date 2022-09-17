# Basalt

## debug

Creates a label with some information on the main frame on the bottom left. When you click on that label it will open a log view for you. See it as the new print for debugging

You can also edit the default debug Label (change position, change color or whatever you want) by accessing the variable `basalt.debugLabel`
which returns the debug Label.

`basalt.debugFrame` and `basalt.debugList` are also available.

### Parameters

1. `...` (multiple parameters are possible, like print does)

### Usage

* Prints "Hello! ^-^" to the debug console

```lua
basalt.debug("Hello! ", "^-^")
```

* Changes the debug label's anchor

```lua
basalt.debugLabel:setAnchor("topLeft") -- default anchor is bottomLeft
basalt.debug("Hello!")
```
