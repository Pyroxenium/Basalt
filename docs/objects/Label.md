A label is for adding simple text.

By default label's width is auto sizing based on the length of the text. If you change the size with setSize it will automatically stop autosizing the width.

The fontsize feature is calculated by bigfonts, a library made by Wojbie (http://www.computercraft.info/forums2/index.php?/topic/25367-bigfont-api-write-bigger-letters-v10/)

Here are all possible functions available for labels.<br>
Remember Label inherits from [Object](objects/Object.md)

## setText
Sets the text which gets displayed.

#### Parameters: 
1. `string` The text which should be displayed

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default label with text "Some random text".
```lua
local mainFrame = basalt.createFrame()
local aLabel = mainFrame:addLabel():setText("Some random text")
```
```xml
<label text="Some random text" />
```

## setFontSize
Sets the font size, calculated by bigfonts. Default size is 1.

#### Parameters: 
1. `number` The size (1, 2, 3, 4)

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default label, sets the text to "Basalt!" and its font size to 2.
```lua
local mainFrame = basalt.createFrame()
local aLabel = mainFrame:addLabel():setText("Basalt!"):setFontSize(2)
```
```xml
<label font="2" />
```

## getFontSize
Returns the current font size

#### Returns:
1. `number` font size

#### Usage:
* Creates a default label, sets the text to "Basalt!" and its font size to 2. Also prints the current fontsize.
```lua
local mainFrame = basalt.createFrame()
local aLabel = mainFrame:addLabel():setText("Basalt!"):setFontSize(2)
basalt.debug(aLabel:getFontSize())
```

## setTextAlign
Changes the text align

#### Returns:
1. `string` horizontal ("left", "center", "right")
1. `string` vertical ("top", "center", "bottom")

#### Usage:
* Creates a default label, sets the text to "Basalt!" changes the horizontal align to right
```lua
local mainFrame = basalt.createFrame()
local aLabel = mainFrame:addLabel():setText("Basalt!"):setTextAlign("right")
```
```xml
<label horizontalAlign="right" verticalAlign="center" />
```
