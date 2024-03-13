Textfields are objects that allow users to write text in multiple lines, similar to the default edit script.

In addition to the Object and VisualObject methods, Textfield objects have the following methods:

|   |   |
|---|---|
|[getLines](objects/Textfield/getLines.md)|Returns all lines of text
|[getLine](objects/Textfield/getLine.md)|Returns a specific line of text
|[editLine](objects/Textfield/editLine.md)|Edits a specific line of text
|[addLine](objects/Textfield/addLine.md)|Adds a new line of text
|[removeLine](objects/Textfield/removeLine.md)|Removes a specific line of text
|[getTextCursor](objects/Textfield/getTextCursor.md)|Returns the current text cursor position
|[addKeywords](objects/Textfield/addKeywords.md)|Adds syntax highlighting keywords
|[addRule](objects/Textfield/addRule.md)|Adds a custom syntax highlighting rule
|[editRule](objects/Textfield/editRule.md)|Edits an existing syntax highlighting rule
|[removeRule](objects/Textfield/removeRule.md)|Removes an existing syntax highlighting rule
|[getOffset](objects/Textfield/getOffset.md)|Returns the current offset inside the Textfield
|[setOffset](objects/Textfield/setOffset.md)|Changes the offset inside the Textfield
|[clear](objects/Textfield/clear.md)|Clears the Textfield content
|[setSelection](objects/Textfield/setSelection.md)|Sets the selection color (text color and background color)
|[getSelection](objects/Textfield/getSelection.md)|Returns the current selection color

In version 1.7, Textfields now allow the user to select text with the mouse. The setSelection method is used to choose the text color and background color for selected text.

## Example

```lua
local main = basalt.createFrame()
local aTextfield = main:addTextfield()

-- Add some lines of text to the Textfield
aTextfield:addLine("This is the first line.")
aTextfield:addLine("This is the second line.")
aTextfield:addLine("This is the third line.")

-- Edit the second line
aTextfield:editLine(2, "This is the modified second line.")

-- Remove the third line
aTextfield:removeLine(3)

-- Add a keyword for syntax highlighting
aTextfield:addKeywords(colors.red, {"first", "second", "third"})
```
