## setSelectedItem
Sets the background and the foreground of the item which is currently selected

#### Parameters: 
1. `number|color` The background color which should be used
2. `number|color` The text color which should be used

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default radio with 4 entries and sets the selection background color to green.
```lua
local mainFrame = basalt.createFrame()
local aRadio = mainFrame:addRadio()
aRadio:addItem("1. Entry",5,2)
aRadio:addItem("2. Entry",5,4,colors.yellow)
aRadio:addItem("3. Entry",5,6,colors.yellow,colors.green)
aRadio:addItem("4. Entry",5,8)
aRadio:setSelectedItem(colors.green, colors.red)
```
```xml
<radio selectionBG="green" selectionFG="red">
  <item><text>1. Entry</text><x>5</x><y>2</y></item>
  <item><text>2. Entry</text><x>5</x><y>4</y><bg>yellow</bg></item>
  <item><text>3. Entry</text><x>5</x><y>6</y><bg>yellow</bg><fg>green</fg></item>
</radio>
```