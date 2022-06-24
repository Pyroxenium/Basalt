This is the base class of all visual objects. This means, if you create a button, label, frame or something else visual (no timers, threads or animations) the following methods apply:

## show
Shows the object (only if the parent frame is already visible)
#### Returns:
1. `object` The object in use

#### Usage:
* Shows a frame named "myFirstFrame"
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local button = mainFrame:addButton("myFirstButton")
button:show()
```

## hide
Hides the object

#### Returns:
1. `object` The object in use

#### Usage:
* Hides a frame named "myFirstFrame"
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local button = mainFrame:addButton("myFirstButton"):setText("Close"):onClick(function() mainFrame:hide() end)
button:show()
```

## setPosition
Changes the position relative to its parent frame
#### Parameters: 
1. `number` x coordinate
2. `number` y coordinate
3. `boolean` Whether it will add/remove to the current coordinates instead of setting them

#### Returns:
1. `object` The object in use

#### Usage:
* Sets the frame's position to an x coordinate of 2 with a y coordinate of 3
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):setPosition(2,3)
```

## setBackground
Changes the object background color, if you set the value to false the background wont be visible. For example you could see trough a frame.
#### Parameters: 
1. `number|color` Background color

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a frame, and sets its background color to `colors.lightGray`
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):setBackground(colors.lightGray)
```

## setForeground
Changes the object text color
#### Parameters: 
1. `number|color` Foreground color

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a frame, and sets its foreground color to `colors.black`
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):setForeground(colors.black)
```

## setSize
Changes the object size
#### Parameters: 
1. `number` width
2. `number` height

#### Returns:
1. `object` The object in use

#### Usage:
* Sets the frame to have a width of 15 and a height of 5
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):setSize(15,5)
```

## setFocus    
Sets the object to be the focused object.
If you click on an object, it's normally automatically the focused object. For example, if you call :show() on a frame, and you want this particular frame to be in
the foreground, you should use :setFocus()
#### Returns:
1. `object` The object in use

#### Usage:
* Sets the button to the focused object
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("myFirstButton"):setFocus():show()
```

## setZIndex
Sets the z index where a higher z index has higher draw/event priority, with higher values higher priority. You are also able to add multiple objects to the same z index. On the same z index: the last created object has the highest priority.
#### Parameters: 
1. `number` z-index

#### Returns:
1. `object` The object in use

#### Usage:
* Sets the z-index of "myFirstButton" to `1`
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("myFirstButton"):setZIndex(1):show()
```

## setParent
Sets the parent frame of the object
#### Parameters: 
1. `frame` The to-be parent frame

#### Returns:
1. `object` The object in use

#### Usage:
* Sets the parent frame of the random frame, adding it to the main frame when the button is clicked"
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aRandomFrame = basalt.createFrame("aRandomFrame"):show()
local aButton = mainFrame:addButton("myFirstButton"):onClick(
        function() 
            aRandomFrame:setParent(mainFrame) 
        end
):show()
```

## isFocused
Returns if the object is currently the focused object of the parent frame

#### Returns: 
1. `boolean` Whether the object is focused

#### Usage:
* Prints whether the button is focused to the debug console
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("myFirstButton"):show()
basalt.debug(aButton:isFocused()) -- shows true or false as a debug message
```

## getAnchorPosition
Converts the x and y coordinates into the anchor coordinates of the object

#### Parameters: 
1. `number|nil` x
2. `number|nil` y, if nothing it uses the object's x, y

#### Returns: 
1. `number` x
2. `number` y

#### Usage:
* Prints the anchor position to the debug console
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):setSize(15,15):show()
local aButton = mainFrame:addButton("myFirstButton")
        :setAnchor("right","bottom")
        :setSize(8,1)
        :setPosition(1,1)
        :show()
basalt.debug(aButton:getAnchorPosition()) -- returns 7,14 (framesize - own size) instead of 1,1
```

## setAnchor
Sets the anchor of the object

#### Parameters: 
1. `string` Anchor sides `("topLeft" "top", "topRight", "right", "bottomRight", "bottom", "bottomLeft", "left", "center")`

#### Returns:
1. `object` The object in use

#### Usage:
* Sets the mainFrame to have an anchor of `right` and aButton to have an anchor of `bottom, right`
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("myFirstButton")
        :setAnchor("bottomRight")
        :setSize(8,1)
        :setPosition(-8,1)
        :show()
```

## getAbsolutePosition
Converts the relative coordinates into absolute coordinates
#### Parameters: 
1. `number|nil` x
2. `number|nil` y

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a frame and a button and prints the button's absolute position to the debug console
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):setPosition(3,3):show()
local aButton = mainFrame:addButton("myFirstButton"):setSize(8,1):setPosition(4,2):show()
basalt.debug(aButton:getAbsolutePosition()) -- returns 7,5 (frame coords + own coords) instead of 4,2
```

## setTextAlign
Sets the text align of the object (for example buttons)
#### Parameters: 
1. `string` horizontal 
2. `string` vertical ("left", "center", "right")

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a button with text aligned to `right, center`
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("myFirstButton")
        :setSize(12,3)
        :setTextAlign("right", "center")
        :setText("Don't...")
        :show()
```

## setValue
Sets the value of that object (input, label, checkbox, textfield, scrollbar,...)
#### Parameters: 
1. `any` Value to set the object to

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a checkbox and ticks it
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aCheckbox = mainFrame:addCheckbox("myFirstCheckbox"):setValue(true):show()
```

## getValue
Returns the currently saved value
#### Returns: 
1. `any` Object's value

#### Usage:
* Prints the value of the checkbox to the debug console
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aCheckbox = mainFrame:addCheckbox("myFirstCheckbox"):setValue(true):show()
basalt.debug(aCheckbox:getValue()) -- returns true
```

## getHeight/getWidth
Returns the respective height/width of the object
#### Returns: 
1. `number` height/width

#### Usage:
* Prints the height of the object to the debug console
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("myFirstButton"):setSize(5,8):show()
basalt.debug(aButton:getHeight()) -- returns 8
```

## isVisible
Returns if the object is currently visible
#### Returns: 
1. `boolean`

#### Usage:
* Prints boolean visibility of object to debug console
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("myFirstButton"):setSize(5,8):show()
basalt.debug(aButton:isVisible()) -- returns true
```

## getName
Returns the given name of the object

#### Returns: 
1. `string` name

#### Usage:
* Prints name of object to debug window
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
basalt.debug(mainFrame:getName()) -- returns myFirstFrame
```

## setShadow
Sets the shadow color - default: colors.black

#### Parameters: 
1. `number|color` Shadow color

#### Returns: 
1. `object` The object in use

#### Usage:
* Sets the shadow to green and shows it:
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local subFrame = mainFrame:addFrame("mySubFrame")
        :setMoveable()
        :setSize(18,6)
        :setShadow(colors.green)
        :showShadow(true)
        :show()
```

## showShadow
Shows or hides the shadow

#### Parameters: 
1. `boolean` Whether it should show or hide the shadow

#### Returns: 
1. `object` The object in use

#### Usage:
* Sets the shadow to green and shows it:
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local subFrame = mainFrame:addFrame("mySubFrame")
        :setMoveable()
        :setSize(18,6)
        :showShadow(true)
        :show()
```

## setBorder
Sets the border color - default: colors.black

#### Parameters: 
1. `number|color` Border color

#### Returns: 
1. `object` The object in use

#### Usage:
* Sets the shadow to green and shows it:
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local subFrame = mainFrame:addFrame("mySubFrame")
        :setMoveable()
        :setSize(18,6)
        :setBorder(colors.green)
        :showBorder("left", "top", "right", "bottom")
        :show()
```

## showBorder
Shows or hides the border

#### Parameters: 
1. `strings` Whether it should show or hide the border on the specific sides ("left", "top", "right", "bottom")

#### Returns: 
1. `object` The object in use

#### Usage:
* Sets the shadow to green and shows it:
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local subFrame = mainFrame:addFrame("mySubFrame")
        :setMoveable()
        :setSize(18,6)
        :showBorder("left", "top", "right", "bottom")
        :show()
```

# Object Events
These events are available for all objects, objects with unique events will have documentation in their respective sections

## onClick
Creates a mouse_click event listener
#### Parameters: 
1. `function` Function handling event listener logic

#### Returns:
1. `object` The object in use

#### Usage:
* Prints to the debug console when the button is clicked
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("myFirstButton"):setSize(10,3):onClick(
        function(self,event,button,x,y) 
            basalt.debug("Hellooww UwU") 
        end
):show()
```

## onClickUp
Creates a click_up event listener
#### Parameters: 
1. `function` Function handling event listener logic

#### Returns:
1. `object` The object in use

#### Usage:
* Prints to the debug console when there is a click_up event
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("myFirstButton"):setSize(10,3):onClickUp(
        function(self,event,button,x,y) 
            basalt.debug("Byeeeee UwU") 
        end
):show()
```

## onMouseDrag
### _Not currently implemented_
Creates a mouse_drag event listener
#### Parameters: 
1. `function` Function handling event listener logic

#### Returns:
1. `object` The object in use

#### Usage:
* Prints to the debug console when the object is dragged
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("myFirstButton"):setSize(10,3):onClickUp(
        function(self,event,button,x,y) 
            basalt.debug("Byeeeee UwU") 
        end
):show()
```

## onChange
Creates an on change event listener (called when the value gets changed)
#### Parameters: 
1. `function` Function handling event listener logic

#### Returns:
1. `object` The object in use

#### Usage:
* Prints the checkbox value to the debug window when changed
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aCheckbox = mainFrame:addCheckbox("myFirstCheckbox"):onChange(
        function(self) 
            basalt.debug("I got changed into " .. self:getValue()) 
        end
):show()
```

## onKey
Creates a keyboard event listener that can be key or character based
#### Parameters: 
1. `function` Function handling event listener logic

#### Returns:
1. `object` The object in use

#### Usage:
* Prints the clicked key to the debug window
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):onKey(
        function(self,event,key) 
            basalt.debug("You clicked " .. key) 
        end
):show()
```

## onLoseFocus
Creates a lose focus event listener
#### Parameters: 
1. `function` Function handling event listener logic

#### Returns:
1. `object` The object in use

#### Usage:
* Prints "Please come back... :(" to the debug window when the frame loses focus
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):onLoseFocus(
        function(self) 
            basalt.debug("Please come back... :(") 
        end
):show()
```

## onGetFocus
Creates a get focus event listener
#### Parameters: 
1. `function` Function handling event listener logic

#### Returns:
1. `object` The object in use

#### Usage:
* Prints "Thanks!" to the debug window when "myFirstFrame" is focused
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):onGetFocus(
        function(self) 
            basalt.debug("Thanks!") 
        end
):show()
```
