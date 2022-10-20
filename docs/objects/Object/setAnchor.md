# Object

## setAnchor

Sets the anchor of the object

### Parameters

1. `string` Anchor sides `("topLeft" "top", "topRight", "right", "bottomRight", "bottom", "bottomLeft", "left", "center")`

### Returns

1. `object` The object in use

### Usage

* Sets the button to have an anchor of `bottomRight`

```lua
local mainFrame = basalt.createFrame():show()
local aButton = mainFrame:addButton()
        :setAnchor("bottomRight")
        :setSize(8,1)
        :setPosition(-8,1)
```

```xml
<button anchor="bottomRight" />
```
