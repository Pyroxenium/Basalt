Scrollbars are objects, the user can scroll vertically or horizontally, this can change the value.<br>
Here is a example of how to create a standard scrollbar:

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aScrollbar = mainFrame:addScrollbar("myFirstScrollbar"):show()
````
Here are all possible functions available for scrollbars. Remember Scrollbar inherits from [Object](objects/Object.md)

## setSymbol
Changes the symbol

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aScrollbar = mainFrame:addScrollbar("myFirstScrollbar"):setSymbol("X"):show()
````
**parameters:** char symbol<br>
**returns:** self<br>

## setBackgroundSymbol
Changes the background symbol color

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aScrollbar = mainFrame:addScrollbar("myFirstScrollbar"):setSymbol("X"):setBackgroundSymbol(colors.green):show()
````
**parameters:** number symbolcolor<br>
**returns:** self<br>

## setBarType
If the bar goes vertically or horizontally

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aScrollbar = mainFrame:addScrollbar("myFirstScrollbar"):setBarType("horizontal"):show()
````
**parameters:** string value ("vertical" or "horizontal")<br>
**returns:** self<br>

## setMaxValue
the default max value is always the width (if horizontal) or height (if vertical), if you change the max value the bar will always calculate the value based on its width or height - example: you set the max value to 100, the height is 10 and it is a vertical bar, this means if the bar is on top, the value is 10, if the bar goes one below, it is 20 and so on.

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aScrollbar = mainFrame:addScrollbar("myFirstScrollbar"):setMaxValue(123):show()
````
**parameters:** any number<br>
**returns:** self<br>
