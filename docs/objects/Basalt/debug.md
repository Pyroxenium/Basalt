## debug

### Description

Creates a label with some information on the main frame in the bottom left corner. When you click on that label, it will open a log view for you. Think of it as the new print for debugging.

You can also edit the default debug label (change position, change color, or whatever you want) by accessing the variable `basalt.debugLabel`, which returns the debug label.

`basalt.debugFrame` and `basalt.debugList` are also available.

### Parameters

1. `...` (multiple parameters are possible, like print does)

### Usage

* Prints "Hello! ^-^" to the debug console

```lua
basalt.debug("Hello! ", "^-^")
```