# Object

## setPosition

Changes the position relative to its parent frame

### Parameters

1. `number|string` x coordinate as number or dynamicvalue as string
2. `number|string` y coordinate as number or dynamicvalue as string
3. `boolean` Whether it will add/remove to the current coordinates instead of setting them

### Returns

1. `object` The object in use

### Usage

* Sets the Buttons position to an x coordinate of 2 with a y coordinate of 3

```lua
local mainFrame = basalt.createFrame()
mainFrame:addButton():setPosition(2,3)
```

```xml
<button x="2" y="3" />
```

if you prefer to use dynamic values:

```lua
local mainFrame = basalt.createFrame()
mainFrame:addButton():setPosition("parent.w * 0.5", 23)
```

```xml
<button x="parent.w * 0.5" y="3" />
```
