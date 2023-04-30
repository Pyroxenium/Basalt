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

### Dynamic Values

Dynamic values can be used to automatically calculate and set the size of an object based on expressions. They can include mathematical operations and reference the size or position of other objects or the object itself. Instead of using static numbers, you can use dynamic values as strings. Here's an example of using dynamic values with `setSize`:

```lua
local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton("objectID")
local secondButton = mainFrame:addButton():setSize("objectID.w * 0.5", "parent.h * 0.25")
```

In this example, the width of `secondButton` is set to half the width of `aButton`, and its height is set to one-quarter of its parent's height. You can use `parent`, `self`, or an object ID to reference different objects when using dynamic values.
