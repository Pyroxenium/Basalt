## setTextAlign

Sets the text alignment within the Label object. It can be left, center, or right aligned.

### Parameters

1. `string` The text alignment ("left", "center", "right")

### Returns

1. `object` The object in use

### Usage

* Creates a default label with text "Some random text" and sets the text alignment to "center".

```lua
local mainFrame = basalt.createFrame()
local aLabel = mainFrame:addLabel():setText("Some random text"):setTextAlign("center")
```

```xml
<label text="Some random text" align="center" />
```
