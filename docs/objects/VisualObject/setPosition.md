## setPosition

### Description

Changes the position relative to its parent frame

### Parameters

1. `number|string` The x coordinate as a number or a dynamic value as a string
2. `number|string` The y coordinate as a number or a dynamic value as a string
3. `boolean` (optional) Whether to add/remove the given coordinates to the current position instead of setting them directly. Default is `false`.

### Returns

1. `object` The object in use

### Usage

* Set the button's position to an x coordinate of 2 and a y coordinate of 3:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
mainFrame:addButton():setPosition(2, 3)
```

```xml
<button x="2" y="3" />
```

* Use dynamic values for the button's position:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
mainFrame:addButton():setPosition("parent.w * 0.5", 23)
```

```xml
<button x="parent.w * 0.5" y="23" />
```

In this example, the x coordinate is set to 50% of the parent frame's width.

### Dynamic Values

Dynamic values are special strings that allow you to set properties of an object based on calculations or the properties of other objects. These values are written as expressions inside double quotes (" "). The expressions can include arithmetic operations, functions, and references to other objects or their properties.

You can use parent, self, or an object's ID to reference other objects when creating dynamic values.

* `parent`: Refers to the object's parent.
* `self`: Refers to the object itself.
* `objectID`: Refers to an object with the given ID.

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local firstButton = mainFrame:addButton("objectID"):setPosition(2, 2)
local secondButton = mainFrame:addButton():setPosition("objectID.w + objectID.x + 2", 2)
```

In this example, the second button's x position is calculated based on the first button's (with the ID objectID) width and x position, with an additional offset of 2.
