# Object

## setBorder

Sets the border of that objects, if false the border will be removed

Default: false

### Parameters

1. `number|color` Border color
2. `string` optional - sides. If you don't set sides, all 4 sides will have a border

### Returns

1. `object` The object in use

### Usage

* Sets the border to green and shows it:

```lua
local mainFrame = basalt.createFrame()
local subFrame = mainFrame:addFrame()
        :setMovable()
        :setSize(18,6)
        :setBorder(colors.green, "left", "right", "bottom")
```

```xml
<frame width="18" height="6" borderColor="green" movable="true" />
```
