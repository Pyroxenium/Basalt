Buttons are objects, which execute function by clicking on them

The following list is only available to buttons: <br>
Remember button also inherits from [object](objects/Object.md):

## setText
Sets the displayed button text
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("myFirstButton"):setText("Click"):show() -- you could also use :setValue() instead of :setText() - no difference
````
**Arguments:** string text<br>
**returns:** self<br>

# Examples
Add a onClick event:
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("myFirstButton"):setText("Click"):onClick(function(self,event,button,x,y)
if(event=="mouse_click")and(button==1)then
basalt.debug("Left mousebutton got clicked!")
end
end):show()
````