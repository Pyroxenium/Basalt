# Object

## getName

Returns the given name of the object

### Returns

1. `string` name

#### Usage

* Prints name of object to debug window

```lua
local main = basalt.createFrame()
basalt.debug(main:getName()) -- returns the uuid
```

```lua
local main = basalt.createFrame("myFirstMainFrame")
basalt.debug(main:getName()) -- returns myFirstMainFrame
```
