## removeChildren

### Description

The `removeChildren` method allows you to remove all child objects from a parent container. This is helpful when you want to clear all elements within a container object, such as a frame, and start with a clean slate.

### Returns

1. `object` The object in use

### Usage

```lua
local mainFrame = basalt.createFrame()

-- Add some child objects to the frame
mainFrame:addLabel("label1", "Hello", 5, 5)
mainFrame:addButton("button1", "Click Me", 5, 10)

-- Remove all child objects from the frame
mainFrame:removeChildren()
```
