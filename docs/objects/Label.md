# Label

With the Label object you are able to add some text.

By default label's width is auto sizing based on the length of the text. If you change the size with setSize it will automatically stop autosizing the width.

Here are all possible functions available for labels.<br>
Remember label inherits from [object](/Object):

## setText
sets the text which gets displayed.
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aInput = mainFrame:addLabel("myFirstLabel"):setText("Hello lovely basalt community!"):show()
````
**arguments:** string text<br>
**returns:** self<br>