# Object

## setSize

Changes the object size

### Parameters

1. `number|string` width as number or dynamicvalue as string
2. `number|string` height as number or dynamicvalue as string

### Returns

1. `object` The object in use

### Usage

* Sets the frame to have a width of 15 and a height of 12

```lua
local mainFrame = basalt.createFrame()
local subFrame = mainFrame:addFrame():setSize(15,12)
```

```xml
<frame width="15" height="12" />
```
