This is the base class for all visual objects. Which means, if you create a button, label, frame or something else (no timers, threads or animations) the following methods apply:

## show
Shows the object (only if the parent frame is already visible)
#### Returns:
1. `object` The object in use

#### Usage:
* Shows a frame
```lua
local mainFrame = basalt.createFrame()
local button = mainFrame:addButton()
button:show()
```
```xml
<button visible="true" />
```

## hide
Hides the object

#### Returns:
1. `object` The object in use

#### Usage:
* Hides a frame
```lua
local mainFrame = basalt.createFrame()
local button = mainFrame:addButton():setText("Close"):onClick(function() mainFrame:hide() end)
```
```xml
<button visible="false" />
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
* Sets the Buttons position to an x coordinate of 2 with a y coordinate of 3
```lua
local mainFrame = basalt.createFrame()
mainFrame:addButton():setPosition(2,3)
```
```xml
<button x="2" y="3" />
```

## setBackground
Changes the object background color, if you set the value to false the background wont be visible. For example you could see trough a frame.
#### Parameters: 
1. `number|color` Background color

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a frame, and sets its background color to `colors.gray`
```lua
local mainFrame = basalt.createFrame():setBackground(colors.gray)
```
```xml
<button bg="gray" />
```

## setForeground
Changes the object text color
#### Parameters: 
1. `number|color` Foreground color

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a frame, and sets its foreground color to `colors.green`
```lua
local mainFrame = basalt.createFrame():setForeground(colors.green)
```
```xml
<button fg="green" />
```

## setSize
Changes the object size
#### Parameters: 
1. `number` width
2. `number` height

#### Returns:
1. `object` The object in use

#### Usage:
* Sets the frame to have a width of 15 and a height of 12
```lua
local mainFrame = basalt.createFrame()
local subFrame = mainFrame:addFrame():setSize(15,12)
```
```xml
<frame width="15" height="12" />
```

## setFocus    
Sets the object to be the focused object.
If you click on an object, it's normally automatically the focused object. For example, if you call :show() on a frame, and you want this particular frame to be in
the foreground, you should also use :setFocus()
#### Returns:
1. `object` The object in use

#### Usage:
* Sets the button to the focused object
```lua
local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setFocus()
```

## setZIndex
Sets the z-index. Higher value means higher draw/event priority. You can also add multiple objects to the same z-index, if so the last added object will have the highest priority.
#### Parameters: 
1. `number` z-index

#### Returns:
1. `object` The object in use

#### Usage:
* Sets the buttons z-index to `1` and the labels z-index to `2`
```lua
local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setZIndex(1):setPosition(2,2)
local aLabel = mainFrame:addButton():setZIndex(2):setPosition(2,2):setText("I am a label!")
```
```xml
<button x="2" y="2" zIndex="1" />
<label x="2" y="2" text="I am a label!" zIndex="2" />
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
local mainFrame = basalt.createFrame()
local aRandomFrame = basalt.createFrame()
local aButton = mainFrame:addButton():onClick(
        function() 
            aRandomFrame:setParent(mainFrame) 
        end
)
```

## isFocused
Returns if the object is currently the focused object of the parent frame

#### Returns: 
1. `boolean` Whether the object is focused

#### Usage:
* Prints whether the button is focused to the debug console
```lua
local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton()
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
local mainFrame = basalt.createFrame():setSize(15,15)
local aButton = mainFrame:addButton()
        :setAnchor("bottomRight")
        :setSize(8,1)
        :setPosition(1,1)
basalt.debug(aButton:getAnchorPosition()) -- returns 7,14 (framesize - own size) instead of 1,1
```

## setAnchor
Sets the anchor of the object

#### Parameters: 
1. `string` Anchor sides `("topLeft" "top", "topRight", "right", "bottomRight", "bottom", "bottomLeft", "left", "center")`

#### Returns:
1. `object` The object in use

#### Usage:
* Sets the button to have an anchor of `bottomRight`
```lua
local mainFrame = basalt.createFrame():show()
local aButton = mainFrame:addButton()
        :setAnchor("bottomRight")
        :setSize(8,1)
        :setPosition(-8,1)
```
```xml
<button anchor="bottomRight" />
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
local mainFrame = basalt.createFrame():setPosition(3,3)
local aButton = mainFrame:addButton():setSize(8,1):setPosition(4,2)
basalt.debug(aButton:getAbsolutePosition()) -- returns 7,5 (frame coords + own coords) instead of 4,2
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
local mainFrame = basalt.createFrame()
local aCheckbox = mainFrame:addCheckbox():setValue(true)
```
```xml
<checkbox value="true" />
```

## getValue
Returns the currently saved value
#### Returns: 
1. `any` Object's value

#### Usage:
* Prints the value of the checkbox to the debug console
```lua
local mainFrame = basalt.createFrame()
local aCheckbox = mainFrame:addCheckbox():setValue(true)
basalt.debug(aCheckbox:getValue()) -- returns true
```

## getHeight/getWidth
Returns the respective height/width of the object
#### Returns: 
1. `number` height/width

#### Usage:
* Prints the height of the object to the debug console
```lua
local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setSize(5,8)
basalt.debug(aButton:getHeight()) -- returns 8
```

## isVisible
Returns if the object is currently visible
#### Returns: 
1. `boolean`

#### Usage:
* Prints boolean visibility of object to debug console
```lua
local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setSize(5,8)
basalt.debug(aButton:isVisible()) -- returns true
```

## getName
Returns the given name of the object

#### Returns: 
1. `string` name

#### Usage:
* Prints name of object to debug window
```lua
local mainFrame = basalt.createFrame()
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
local mainFrame = basalt.createFrame()
local subFrame = mainFrame:addFrame()
        :setMoveable()
        :setSize(18,6)
        :setShadow(colors.green)
        :showShadow(true)
```
```xml
<frame width="18" height="6" shadow="true" shadowColor="green" moveable="true" />
```

## showShadow
Shows or hides the shadow

#### Parameters: 
1. `boolean` Whether it should show or hide the shadow

#### Returns: 
1. `object` The object in use

#### Usage:
* Shows the shadow:
```lua
local mainFrame = basalt.createFrame()
local subFrame = mainFrame:addFrame()
        :setMoveable()
        :setSize(18,6)
        :showShadow(true)
```
```xml
<frame width="18" height="6" shadow="true" moveable="true" />
```

## setBorder
Sets the border color - default: colors.black

#### Parameters: 
1. `number|color` Border color

#### Returns: 
1. `object` The object in use

#### Usage:
* Sets the border to green and shows it:
```lua
local mainFrame = basalt.createFrame()
local subFrame = mainFrame:addFrame()
        :setMoveable()
        :setSize(18,6)
        :setBorder(colors.green)
        :showBorder("left", "top", "right", "bottom")
```
```xml
<frame width="18" height="6" border="true" borderColor="green" moveable="true" />
```

## showBorder
Shows or hides the border

#### Parameters: 
1. `strings` Whether it should show or hide the border on the specific sides ("left", "top", "right", "bottom")

#### Returns: 
1. `object` The object in use

#### Usage:
* Shows the border:
```lua
local mainFrame = basalt.createFrame()
local subFrame = mainFrame:addFrame()
        :setMoveable()
        :setSize(18,6)
        :showBorder("left", "top", "bottom")
```
```xml
<frame width="18" height="6" border="true" borderColor="green" borderRight="false" moveable="true" />
```