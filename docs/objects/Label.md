With the Label object you are able to add some text.

By default label's width is auto sizing based on the length of the text. If you change the size with setSize it will automatically stop autosizing the width.

Here are all possible functions available for labels.<br>
Remember Label inherits from [Object](objects/Object.md)

## setText
sets the text which gets displayed.
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aInput = mainFrame:addLabel("myFirstLabel"):setText("Hello lovely basalt community!"):show()
````
**arguments:** string text<br>
**returns:** self<br>

## setFontSize
sets the font size of that text.
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aInput = mainFrame:addLabel("myFirstLabel"):setText("Hello"):setFontSize(2):show()
````
**arguments:** number size (1 = default, 2 = big, 3 = bigger, 4 = huge)<br>
**returns:** self<br>

## getFontSize
returns the fontsize
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aInput = mainFrame:addLabel("myFirstLabel"):setText("Hello"):setFontSize(2):show()
basalt.debug(aInput:getFontSize()) -- returns 2
````
**arguments:** <br>
**returns:** number<br>
