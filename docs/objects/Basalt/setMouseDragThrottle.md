## setMouseDragThrottle

### Description

Changes the drag throttle of all drag events. Default value is 50ms - which is 0.05s.
Instead of sending all mouse_drag events to the :onDrag handlers basalt sends every 0.05s (while dragging) the most recent drag event to all
drag handlers. If you need all drag events - just change the value to 0.

### Parameters

1. `number` throttle - A number in milliseconds representing the drag throttle.

### Usage

* Set the drag throttle to 0, which sends all drag events to the handlers

```lua
local basalt = require("basalt")
basalt.setMouseDragThrottle(0)
```
