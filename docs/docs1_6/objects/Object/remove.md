# Object

## remove

Removes the object from it's parent frame. This won't 'destroy' the object, It will continue to exist as long as you still have pointers to it.

Here is a example on how a button will be fully removed from the memory:

```lua
local main = basalt.createFrame()
local button = main:addButton():setPosition(2,2):setText("Close")

button:remove()
button = nil
```
