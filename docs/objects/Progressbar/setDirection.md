## setDirection

### Description

Sets the direction in which the ProgressBar should expand.

### Parameters

1. `number` The direction of expansion (0 = left to right, 1 = top to bottom, 2 = right to left, and 3 = bottom to top)

### Returns

1. `object` The object in use

### Usage

* Creates a progressbar and sets the direction from bottom to top

```lua
local mainFrame = basalt.createFrame()
local aProgressbar = mainFrame:addProgressbar()
aProgressbar:setDirection(3)
```

In this example, a ProgressBar object is created and added to the mainFrame. The setPosition and setSize methods are used to adjust the position and size of the ProgressBar. The setProgress method is used to set the current progress to 50. The setDirection method is used to set the direction of expansion from bottom to top.

```xml
<frame direction="3"></frame>
```
