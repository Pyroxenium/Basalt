## add&#60;Object&#62;
Adds a new object. Don't use add&#60;Object&#62; please use addTheObjectYouNeed. For example if you want a new Frame, use
addFrame, if you want to add a button, use addButton.

#### Parameters:
1. `string` optional - the id if you don't add a id it will automatically generate one for you

#### Returns:
1. `object` The new object you've created

#### Usage:
* Creates some example objects
```lua
local main = basalt.createFrame()
local button = main:addButton()
local label = main:addLabel()
local frame = main:addFrame()
```
