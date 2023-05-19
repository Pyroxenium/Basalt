## addBreak

### Description

The `addBreak` method adds a line break to the Flexbox container. This causes the subsequent children to start on a new line or column, depending on the flex direction. This is helpful when you want to control the arrangement of children within the Flexbox container.

### Returns

1. `object` The object in use

### Usage

* Creates a default Flexbox, adds some objects to it, and then adds a break before adding more objects.

```lua
local main = basalt.createFrame()
local flexbox = mainFrame:addFlexbox()
flexbox:addButton()
flexbox:addButton()
flexbox:addBreak() -- adds a line break
flexbox:addButton() -- this object will start on a new line
```
