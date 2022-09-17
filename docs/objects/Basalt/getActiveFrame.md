# Basalt

## getActiveFrame

Returns the currently active/visible base frame.

### Returns

1. `frame` The current frame

### Usage

* Displays the active frame name in the debug console

```lua
local main = basalt.createFrame()
basalt.debug(basalt.getActiveFrame():getName()) -- returns the id
```
