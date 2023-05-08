## setMouseMoveThrottle

### Description

This feature is only available for [CraftOS-PC](https://www.craftos-pc.cc).

CraftOS-PC has a built-in `mouse_move` event, which is disabled by default. By using this method, it will also enable the event for you. Remember, Basalt does not disable the event after closing the program, which means the event stays active. If you want to disable the event, please use `config.set("mouse_move_throttle", -1)` in your Lua prompt or your program.

Sidenote: A very low amount can make the program laggy because it literally spams the `mouse_move` event. So, use it carefully.

### Parameters

1. `number` throttle - A number in milliseconds representing the mouse move throttle.

### Usage

* Set the mouse move throttle to 50 milliseconds

```lua
local basalt = require("basalt")
basalt.setMouseMoveThrottle(50)
```
