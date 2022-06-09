With sliders you can add a object where the user can change a number value.<br><br>

Here are all possible functions available for sliders: <br>
Remember slider also inherits from [object](https://github.com/NoryiE/Basalt/wiki/Object)

## setSymbol
this will change the foreground symbol
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aSlider = mainFrame:addSlider("myFirstSlider"):setSymbol("X"):show()
```
#### Parameters: char symbol<br>
#### Returns: self<br>

## setBackgroundSymbol
this will change the symbol background color
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aSlider = mainFrame:addSlider("myFirstSlider"):setBackgroundSymbol(colors.yellow):show()
```
#### Parameters: number color<br>
#### Returns: self<br>

## setSymbolColor
this will change the symbol color
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aSlider = mainFrame:addSlider("myFirstSlider"):setSymbolColor(colors.red):show()
```
#### Parameters: number color<br>
#### Returns: self<br>

## setBarType
this will change the bar to vertical/horizontal (default is horizontal)
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aSlider = mainFrame:addSlider("myFirstSlider"):setBarType("vertical"):show()
```
#### Parameters: string value ("vertical", "horizontal"<br>
#### Returns: self<br>


