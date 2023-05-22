Flexbox is an incredibly powerful tool for layout design in Basalt, it allows for dynamic positioning of elements in both rows and columns. This can make your program look much neater, and also simplify the placement and resizing of elements.

In addition to the methods inherited from Frame, Container, VisualObject and Object, Flexbox has the following methods:

|   |   |
|---|---|
|[setDirection](objects/BaseFrame/getOffset.md)|Sets the direction in which the children will be placed
|[getDirection](objects/BaseFrame/getOffset.md)|Returns the direction
|[setSpacing](objects/BaseFrame/setOffset.md)|Sets the space between objects
|[getSpacing](objects/BaseFrame/setOffset.md)|Returns the space
|[setJuustifyContent](objects/BaseFrame/getOffset.md)|Determines how the children are aligned along the main axis
|[getJuustifyContent](objects/BaseFrame/getOffset.md)|Returns the justify content

## Examples

### Nested Flexbox

Flexboxes can be nested within each other to create more complex layouts. This example demonstrates how to nest flexboxes.

<details>
<summary>Click here to show code</summary>

```lua
local flex = main:addFlexbox():setWrap("wrap"):setBackground(colors.lightGray):setPosition(1, 1):setSize("parent.w", "parent.h")

flex:addButton():setSize(10, 3)
flex:addButton():setSize(15, 3)
flex:addButton():setSize(8, 3)
flex:addButton():setSize(20, 3)
flex:addButton()
flex:addButton():setSize(10, 3)
flex:addButton():setSize(15, 3)
flex:addButton():setSize(8, 3)
flex:addButton():setSize(20, 3)
```

</details>
<br>

![Flexbox example](../_media/flexbox-example.png "Flexbox example")

### FlexGrow Property

<details>
<summary>Click here to show code</summary>

```lua
local basalt = require("basalt")

local main = basalt.createFrame()

local function makeResizeable(frame, minW, minH, maxW, maxH)
    minW = minW or 4
    minH = minH or 4
    maxW = maxW or 99
    maxH = maxH or 99
    local btn = frame:addButton()
        :ignoreOffset()
        :setPosition("parent.w", "parent.h")
        :setSize(1, 1)
        :setText("/")
        :setForeground(colors.black)
        :setBackground(colors.gray)
        :onDrag(function(self, _, _, xOffset, yOffset)
            local w, h = frame:getSize()
            local wOff, hOff = w, h
            if(w+xOffset-1>=minW)and(w+xOffset-1<=maxW)then
                wOff = w+xOffset-1
            end
            if(h+yOffset-1>=minH)and(h+yOffset-1<=maxH)then
                hOff = h+yOffset-1
            end
            frame:setSize(wOff, hOff)
        end)
end

local flexFrame = main:addMovableFrame():setSize(23, 12):setPosition(2, 2):setBackground(colors.gray):setBorder(colors.black)
local flex = flexFrame:addFlexbox():setWrap("wrap"):setPosition(2, 2):setSize("parent.w - 2", "parent.h - 2"):setBackground(colors.gray):setForeground(colors.black):setTheme({ButtonBG=colors.black, ButtonText=colors.lightGray})
flex:addButton():setFlexBasis(1):setFlexGrow(1)
flex:addButton():setFlexBasis(1):setFlexGrow(1)
flex:addButton():setFlexBasis(1):setFlexGrow(1)
flex:addButton():setFlexBasis(1):setFlexGrow(1)
flex:addButton():setFlexBasis(1):setFlexGrow(1)
flex:addButton():setFlexBasis(1):setFlexGrow(1)
flex:addButton():setFlexBasis(1):setFlexGrow(1)
flex:addButton():setFlexBasis(1):setFlexGrow(1)

makeResizeable(flexFrame, 11, 6)

basalt.autoUpdate()
```

</details>
<br>
<video width="600" controls autoplay loop muted>
  <source src="./_media/flexgrow-property.mp4" type="video/mp4">
</video>

#### Another example

This is another example, which shows how frames work with flexbox

<details>
<summary>Click here to show code</summary>

```lua
local basalt = require("BasaltDev2")

local main = basalt.createFrame()

local function makeResizeable(frame, minW, minH, maxW, maxH)
    minW = minW or 4
    minH = minH or 4
    maxW = maxW or 99
    maxH = maxH or 99
    local btn = frame:addButton()
        :ignoreOffset()
        :setPosition("parent.w", "parent.h")
        :setSize(1, 1)
        :setText("/")
        :setForeground(colors.black)
        :setBackground(colors.gray)
        :onDrag(function(self, _, _, xOffset, yOffset)
            local w, h = frame:getSize()
            local wOff, hOff = w, h
            if(w+xOffset-1>=minW)and(w+xOffset-1<=maxW)then
                wOff = w+xOffset-1
            end
            if(h+yOffset-1>=minH)and(h+yOffset-1<=maxH)then
                hOff = h+yOffset-1
            end
            frame:setSize(wOff, hOff)
        end)
end

local flexFrame = main:addMovableFrame():setSize(23, 12):setPosition(2, 2):setBackground(colors.gray):setBorder(colors.black)
local flex = flexFrame:addFlexbox():setWrap("wrap"):setPosition(2, 2):setSize("parent.w - 2", "parent.h - 2"):setBackground(colors.gray):setForeground(colors.black):setTheme({ButtonBG=colors.black, ButtonText=colors.lightGray})
local f1 = flex:addFrame():setBackground(colors.black):setSize(25, 10):setFlexBasis(1):setFlexGrow(1)
local f2 = flex:addFrame():setBackground(colors.black):setSize(25, 10):setFlexBasis(1):setFlexGrow(1)

f1:addLabel():setForeground(colors.lightGray):setText("Frame 1"):setPosition("parent.w/2-self.w/2", 2)
f1:addButton():setText("Button"):setPosition(2, 4):setBackground(colors.gray):setForeground(colors.black):setSize("math.floor(parent.w - 2)", 3)
f2:addLabel():setForeground(colors.lightGray):setSize("parent.w", "parent.h"):setText("lorem ipsum dolor sit amet, consectetur adipiscing elit. sed non risus. suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. cras elementum ultrices diam. maecenas ligula massa, varius a, semper congue, euismod non, mi. proin porttitor, orci nec nonummy molestie, enim est eleifend mi, non fermentum diam nisl sit amet erat. Duis semper. Duis arcu massa, scelerisque vitae, consequat in, pretium a, enim. Pellentesque congue. Ut in risus volutpat libero pharetra tempor. Cras vestibulum bibendum augue. Praesent egestas leo in pede. Praesent blandit odio eu enim. Pellentesque sed dui ut augue blandit sodales. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Aliquam nibh. Mauris ac mauris sed pede pellentesque fermentum. Maecenas adipiscing ante non diam sodales hendrerit.")
makeResizeable(flexFrame, 11, 6)

basalt.autoUpdate()
```

</details>
<br>
<video width="600" controls autoplay loop muted>
  <source src="./_media/frame-flexgrow-property.mp4" type="video/mp4">
</video>
