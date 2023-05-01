## setScrollable
Makes it possible to scroll while the mouse is over the menubar

#### Parameters: 
1. `boolean` If the menubar should be scrollable or not

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a new menubar and makes it scrollable
```lua
local main = basalt.createFrame()
local aMenubar = main:addMenubar():setScrollable(true)
  :addItem("1. Entry")
  :addItem("2. Entry")
  :addItem("3. Entry")
  :addItem("4. Entry")
  :addItem("5. Entry")
  :addItem("6. Entry")
  :addItem("7. Entry")
  :addItem("8. Entry")
  :addItem("9. Entry")

```
```xml
<menubar scrollable="true">
  <item><text>1. Entry</text></item>
  <item><text>2. Entry</text></item>
  <item><text>3. Entry</text></item>
  <item><text>4. Entry</text></item>
  <item><text>5. Entry</text></item>
  <item><text>6. Entry</text></item>
  <item><text>7. Entry</text></item>
  <item><text>8. Entry</text></item>
  <item><text>9. Entry</text></item>
</menubar>
```