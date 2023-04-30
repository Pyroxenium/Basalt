## setInputLimit

### Description

Sets a character limit for the Input object, restricting the number of characters that can be entered.

### Parameters

1. `number` characterLimit - The maximum number of characters allowed.

### Returns

1. `object` The object in use

### Usage

* Creates a default input and sets the character limit to 8.

```lua
local mainFrame = basalt.createFrame()
local aInput = mainFrame:addInput():setInputLimit(8)
```

```xml
<input limit="8" />
```
