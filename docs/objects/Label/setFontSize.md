## setFontSize

### Description

Sets the font size for the Label object, calculated by bigfonts. Default size is 1.

### Parameters

1. `number` The size (1, 2, 3, 4)

### Returns

1. `object` The object in use

### Usage

* Creates a default label, sets the text to "Basalt!" and its font size to 2.

```lua
local mainFrame = basalt.createFrame()
local aLabel = mainFrame:addLabel():setText("Basalt!"):setFontSize(2)
```

```xml
<label text="Basalt!" fontSize="2" />
```
