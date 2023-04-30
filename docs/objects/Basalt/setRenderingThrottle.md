## setRenderingThrottle

### Description

Sets the rendering throttle for Basalt's automatic update process. This determines how often the screen is updated during the auto-update loop. A higher value means the screen updates less frequently, potentially reducing CPU usage and improving performance, while a lower value results in more frequent updates, ensuring smoother animations and responsiveness.

### Parameters

1. `number` throttle - The throttle value in milliseconds. Default value is 50ms (0.05 seconds).

### Usage

* Sets the rendering throttle to 100ms (0.1 seconds).

```lua
local basalt = require("basalt")
basalt.setMouseMoveThrottle(100)
```
