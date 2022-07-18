Scrollbars are objects, the user can scroll vertically or horizontally, this will change a value, which you can access by :getValue().<br>

Remember scrollbar also inherits from [Object](objects/Object.md)

## setSymbol
Changes the scrollbar symbol, default is " "

#### Parameters: 
1. `string` symbol

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a new scrollbar and changes the symbol to X
```lua
local mainFrame = basalt.createFrame()
local scrollbar = mainFrame:addScrollbar():setSymbol("X")
```
```xml
<scrollbar symbol="X" />
```

## setBackgroundSymbol
Changes the symbol in the background, default is "\127"

#### Parameters: 
1. `string` symbol

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a new scrollbar and changes the background symbol to X
```lua
local mainFrame = basalt.createFrame()
local scrollbar = mainFrame:addScrollbar():setBackgroundSymbol("X")
```
```xml
<scrollbar backgroundSymbol="X" />
```

## setBarType
Changes the scrollbar to be vertical or horizontal, default is vertical

#### Parameters: 
1. `string` vertical or horizontal

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a new scrollbar and changes the bar type to horizontal
```lua
local mainFrame = basalt.createFrame()
local scrollbar = mainFrame:addScrollbar():setBarType("horizontal")
```
```xml
<scrollbar barType="horizontal" />
```

## setMaxValue
the default max value is always the width (if horizontal) or height (if vertical), if you change the max value the bar will always calculate the value based on its width or height - example: you set the max value to 100, the height is 10 and it is a vertical bar, this means if the bar is on top, the value is 10, if the bar goes one below, it is 20 and so on.

#### Parameters: 
1. `number` maximum

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a new scrollbar and changes the max value to 20
```lua
local mainFrame = basalt.createFrame()
local scrollbar = mainFrame:addScrollbar():setMaxValue(20)
```
```xml
<scrollbar maxValue="20" />
```

## setIndex
Changes the current index to your choice, for example you could create a button which scrolls up to 1 by using :setIndex(1)

#### Parameters: 
1. `number` the index

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a new scrollbar and changes the index to 1 as soon as the button got clicked
```lua
local mainFrame = basalt.createFrame()
local scrollbar = mainFrame:addScrollbar():setMaxValue(20)
local button = mainFrame:addButton(function()
    scrollbar:setIndex(1)
end)
```
```xml
<scrollbar index="2" />
```

## getIndex
Returns the current index

#### Returns:
1. `number` index

