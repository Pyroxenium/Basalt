## getVariable

### Description

Returns a variable defined with [setVariable](objects/Basalt/setVariable)

### Returns

1. `variable` The variable stored

### Usage

* Displays the stored variable in the debug console

```lua
basalt.setVariable("abc", function()
  basalt.debug("I got clicked")
  return 1
end)

basalt.debug(basalt.getVariable("abc")()) -- Should debug log "I got clicked" and debug log 1 (which was returned from the function)
```

```xml
<button onClick="abc" text="Click me" />
```
