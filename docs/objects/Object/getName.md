# Object

## getName

Returns the name of the object

### Returns

1. `string` The name of the object, or a uuid if no name was assigned

#### Usage

* Prints name of object to debug window

```lua
local main = basalt.createFrame()
basalt.debug(main:getName()) -- returns a uuid
```

```lua
local main = basalt.createFrame("myFirstMainFrame")
basalt.debug(main:getName()) -- returns myFirstMainFrame
```
