## addItem
Adds a item to the radio

#### Parameters: 
1. `string` The entry name
2. `number` x position
3. `number` y position
2. `number|color` unique default background color - optional
3. `number|color` unique default text color - optional
4. `any` any value - you could access this later in a :onChange() event (you need to use :getValue()) - optional

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default radio with 3 entries
```lua
local mainFrame = basalt.createFrame()
local aRadio = mainFrame:addRadio()
aRadio:addItem("1. Entry",5,2)
aRadio:addItem("2. Entry",5,4,colors.yellow)
aRadio:addItem("3. Entry",5,6,colors.yellow,colors.green)
```
```xml
<radio>
  <item><text>1. Entry</text><x>5</x><y>2</y></item>
  <item><text>2. Entry</text><x>5</x><y>4</y><bg>yellow</bg></item>
  <item><text>3. Entry</text><x>5</x><y>6</y><bg>yellow</bg><fg>green</fg></item>
</radio>
```