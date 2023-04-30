## setDraggingMap

### Description

Sets the dragging map for the MovableFrame object. The dragging map is used to control which part of the MovableFrame can be used to drag and move the frame.

### Parameters

1. `table` draggingMap - A table containing tables containing the dragging map information. The table should have the following keys:
    * `x1` (number): The starting x-coordinate of the draggable area.
    * `y1` (number): The starting y-coordinate of the draggable area.
    * `x2` (number): The ending x-coordinate of the draggable area.
    * `y2` (number): The ending y-coordinate of the draggable area.

### Returns

1. `object` The object in use

### Usage

* Set the dragging map for a MovableFrame

```lua
local main = basalt.createFrame()
local movableFrame = main:addMovableFrame():setSize(10, 5)
movableFrame:addDraggingMap({
  {x1 = 0, y1 = 0, x2 = 10, y2 = 5}
})
```
