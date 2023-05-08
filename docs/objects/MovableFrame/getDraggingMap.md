## getDraggingMap

### Description

Returns the current dragging map of the MovableFrame object. The dragging map is used to control which part of the MovableFrame can be used to drag and move the frame.

### Returns

1. `table` draggingMap - A table containing tables containing the dragging map information. The table should have the following keys:
    * `x1` (number): The starting x-coordinate of the draggable area.
    * `y1` (number): The starting y-coordinate of the draggable area.
    * `x2` (number): The ending x-coordinate of the draggable area.
    * `y2` (number): The ending y-coordinate of the draggable area.

### Usage

* Get the dragging map for a MovableFrame

```lua
local main = basalt.createFrame()
local movableFrame = main:addMovableFrame():setSize(10, 5)

local draggingMap = movableFrame:getDraggingMap()
for k,v in pairs(draggingMap)do
  basalt.debug("Dragging Map "..k..": x1=" .. v.x1 .. ", y1=" .. v.y1 .. ", x2=" .. v.x2 .. ", y2=" .. v.y2)
end
```
