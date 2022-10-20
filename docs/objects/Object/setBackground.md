# Object

## setBackground

Changes the object background color, if you set the value to false the background wont be visible. For example you could see trough a frame.

### Parameters

1. `number|color` Background color
1. `char` background symbol you want to draw (optional)
1. `number|color` Background symbol color (optional)

### Returns

1. `object` The object in use

### Usage

* Creates a frame, and sets its background color to `colors.gray`, also sets a background symbol with color black.

```lua
local mainFrame = basalt.createFrame():setBackground(colors.gray, "#", colors.black)
```

```xml
<button bg="gray" />
```
