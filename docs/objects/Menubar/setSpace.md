## setSpace

### Description

Sets the space between the entries in the menubar.

### Parameters

1. `number` The space you want between the entries

### Returns

1. `object` The object in use

### Usage

* Creates a default menubar with 4 entries and sets the space between them to 3.

```lua
local main = basalt.createFrame()
local aMenubar = main:addMenubar()
  :addItem("1. Entry")
  :addItem("2. Entry",colors.yellow)
  :addItem("3. Entry",colors.yellow,colors.green)
  :addItem("4. Entry")
  :setSpace(3)
```

```xml
<menubar space="3">
  <item><text>1. Entry</text></item>
  <item><text>2. Entry</text><bg>yellow</bg></item>
  <item><text>3. Entry</text><bg>yellow</bg><fg>green</fg></item>
  <item><text>4. Entry</text></item>
</menubar>
```
