A Label object is used to display simple text on the interface.

In addition to the Object and VisualObject methods, Label objects have the following methods:


|   |   |
|---|---|
|[setText](objects/Label/setText.md)|Sets the input type
|[setFontSize](objects/Label/setFontSize.md)|Returns the input type
|[getFontSize](objects/Label/getFontSize.md)|Sets the default text
|[setTextAlign](objects/Label/setTextAlign.md)|Changes the horizontal text align

By default, a label's width is auto-sized based on the length of the text. If you change the size with setSize, it will automatically stop auto-sizing the width.

The fontsize feature is calculated by bigfonts, a library made by Wojbie (http://www.computercraft.info/forums2/index.php?/topic/25367-bigfont-api-write-bigger-letters-v10/)

Here's an example of how to create a Label object and set its properties:

Lua:

```lua
local main = basalt.createFrame()
local aLabel = main:addLabel()
aLabel:setText("Hello, World!")
aLabel:setFontSize(2)
```

XML:

```xml
<label text="Hello World!" fontSize="2" />
```
