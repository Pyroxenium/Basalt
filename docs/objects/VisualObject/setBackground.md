## setBackground

### Description

Changes the object background color. If you set the value to `false`, the background won't be visible, allowing you to see through a frame, for example.

### Parameters

1. `number|color|false` Background color
1. `char` (Optional) Background symbol you want to draw
1. `number|color` (Optional) Background symbol color

### Returns

1. `object` Creates a frame, and sets its background color to colors.gray, also sets a background symbol with color black.

### Usage

* Creates a frame, and sets its background color to `colors.gray`, also sets a background symbol with color black.

```lua
local mainFrame = basalt.createFrame():setBackground(colors.gray, "#", colors.black)
```

```xml
<button bg="gray" />
```
