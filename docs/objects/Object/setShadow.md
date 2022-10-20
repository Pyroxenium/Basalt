# Object

## setShadow

Sets the shadow color - default: false

### Parameters

1. `number|color` Shadow color

#### Returns

1. `object` The object in use

#### Usage

* Sets the shadow to green and shows it:

```lua
local mainFrame = basalt.createFrame()
local subFrame = mainFrame:addFrame()
        :setMovable()
        :setSize(18,6)
        :setShadow(colors.green)
```

Or:

```xml
<frame width="18" height="6" shadowColor="green" movable="true" />
```
