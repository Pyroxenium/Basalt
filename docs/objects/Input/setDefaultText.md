## setDefaultText

### Description

Sets the default text for the Input object. This will only be displayed if there is no input set by the user.

### Parameters

1. `string` default text
2. `number` default background color (optional)
3. `number` default text color (optional)

### Returns

1. `object` The object in use

### Usage

* Creates a default input and sets the default text to "..." with optional background and text colors.

```lua
local mainFrame = basalt.createFrame()
local aInput = mainFrame:addInput():setDefaultText("...", colors.gray, colors.lightGray)
```

```xml
<input default="..." defaultBgColor="gray" defaultTextColor="lightGray" />
```
