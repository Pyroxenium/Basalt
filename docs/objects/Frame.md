Frame is a subclass of the Container class and inherits from VisualObject and Object classes. Frame objects are used for grouping and organizing other objects within a parent object, providing structure to your interface. The main difference between Frame and BaseFrame is that Frame must always have a parent.

In addition to the methods inherited from Container, VisualObject and Object, Frame has the following methods:

|   |   |
|---|---|
|[getOffset](objects/BaseFrame/getOffset.md)|Returns the current offset of the BaseFrame object
|[setOffset](objects/BaseFrame/setOffset.md)|Sets a new offset for the BaseFrame object

## Examples

Here are some examples on how you can use frames to create very advanced programs. Because of the screen size limitation of CC:Tweaked frames can become very useful in almost every scenario. You will find some examples here on how you could implement them.

### Menubar for switching frames

In this example, we create a menubar that helps you switch between frames, without any animations involved.

<details>
<summary>Click here to show code</summary>

```lua
local basalt = require("basalt") -- we need basalt here

local main = basalt.createFrame():setTheme({FrameBG = colors.lightGray, FrameFG = colors.black}) -- we change the default bg and fg color for frames

local sub = { -- here we create a table where we gonna add some frames
    main:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h - 1"), -- obviously the first one should be shown on program start
    main:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h - 1"):hide(),
    main:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h - 1"):hide(),
}

local function openSubFrame(id) -- we create a function which switches the frame for us
    if(sub[id]~=nil)then
        for k,v in pairs(sub)do
            v:hide()
        end
        sub[id]:show()
    end
end

local menubar = main:addMenubar():setScrollable() -- we create a menubar in our main frame.
    :setSize("parent.w")
    :onChange(function(self, val)
        openSubFrame(self:getItemIndex()) -- here we open the sub frame based on the table index
    end)
    :addItem("Example 1")
    :addItem("Example 2")
    :addItem("Example 3")

-- Now we can change our sub frames, if you want to access a sub frame just use sub[subid], some examples:
sub[1]:addButton():setPosition(2, 2)

sub[2]:addLabel():setText("Hello World!"):setPosition(2, 2)

sub[3]:addLabel():setText("Now we're on example 3!"):setPosition(2, 2)
sub[3]:addButton():setText("No functionality"):setPosition(2, 4):setSize(18, 3)

basalt.autoUpdate()
```

</details>
<br>
<video width="600" controls autoplay loop muted>
  <source src="./_media/frames-with-menubars.mp4" type="video/mp4">
</video>

### Sidebar with buttons to switch frames

This example illustrates how to create a sidebar with buttons that can be used to switch between frames. Also note that :setZIndex(25) is used to ensure that the sidebar frame is always displayed on top of the normal subframes.

<details>
<summary>Click here to show code</summary>

```lua
local basalt = require("basalt") -- we need basalt here

local main = basalt.createFrame():setTheme({FrameBG = colors.lightGray, FrameFG = colors.black})

--[[ 
Here we create the sidebar, on focus it should change the position to parent.w - (self.w-1) which "opens the frame"
when the focus gets lost we simply change the position to "parent.w"
As you can see we add :setZIndex(25) - this makes sure the sidebar frame is always more important than our normal sub frames.
:setScrollable just makes the sidebar frame scrollable (in case you're adding more frames)
]]
local sidebar = main:addFrame():setBackground(colors.gray):setPosition("parent.w", 1):setSize(15, "parent.h"):setZIndex(25):setScrollable()
:onGetFocus(function(self)
    self:setPosition("parent.w - (self.w-1)")
end)
:onLoseFocus(function(self)
    self:setPosition("parent.w")
end)

-- Once again we add 3 frames, the first one should be immediatly visible
local sub = {
    main:addFrame():setPosition(1, 1):setSize("parent.w", "parent.h"),
    main:addFrame():setPosition(1, 1):setSize("parent.w", "parent.h"):hide(),
    main:addFrame():setPosition(1, 1):setSize("parent.w", "parent.h"):hide(),
}

--This part of the code adds buttons based on the sub table.
local y = 2
for k,v in pairs(sub)do
    sidebar:addButton():setText("Example "..k) -- creating the button and adding a name k is just the index
    :setBackground(colors.black)
    :setForeground(colors.lightGray)
    :setSize("parent.w - 2", 3)
    :setPosition(2, y)
    :onClick(function() -- here we create a on click event which hides ALL sub frames and then shows the one which is linked to the button
        for a, b in pairs(sub)do
            b:hide()
            v:show()
        end
    end)
    y = y + 4
end

sub[1]:addButton():setPosition(2, 2)

sub[2]:addLabel():setText("Hello World!"):setPosition(2, 2)

sub[3]:addLabel():setText("Now we're on example 3!"):setPosition(2, 2)
sub[3]:addButton():setText("No functionality"):setPosition(2, 4):setSize(18, 3)

basalt.autoUpdate()
```

</details>
<br>
<video width="600" controls autoplay loop muted>
  <source src="./_media/frames-with-sidebar.mp4" type="video/mp4">
</video>

### Movable frames with a program object

In this example, we will demonstrate how to create movable frames with a program object inside. This will also demonstrate how you can dynamically add new frames.

<details>
<summary>Click here to show code</summary>

```lua
local basalt = require("basalt")

local main = basalt.createFrame():setTheme({FrameBG = colors.lightGray, FrameFG = colors.black})

local id = 1
local processes = {}

local function openProgram(path, title, x, y, w, h)
    local pId = id
    id = id + 1
    local f = main:addMovableFrame()
        :setSize(w or 30, h or 12)
        :setPosition(x or math.random(2, 12), y or math.random(2, 8))

    f:addLabel()
        :setSize("parent.w", 1)
        :setBackground(colors.black)
        :setForeground(colors.lightGray)
        :setText(title or "New Program")

    f:addProgram()
        :setSize("parent.w-1", "parent.h - 2")
        :setPosition(1, 2)
        :execute(path or "rom/programs/shell.lua")

    f:addButton()
        :setSize(1, 1)
        :setText("X")
        :setBackground(colors.black)
        :setForeground(colors.red)
        :setPosition("parent.w-1", 1)
        :onClick(function()
            f:remove()
            processes[pId] = nil
        end)
    processes[pId] = f
    return f
end

openProgram("rom/programs/fun/worm.lua")

main:addButton():setPosition("parent.w - 16", 2):setText("Open"):onClick(function()
    openProgram()
end)


basalt.autoUpdate()
```

</details>
<br>
<video width="600" controls autoplay loop muted>
  <source src="./_media/dynamic-frames.mp4" type="video/mp4">
</video>


### Resizable frames

This example shows how to make your frames resizable manually, as Basalt does not offer a built-in way to do this. It is, however, a straightforward process.

<details>
<summary>Click here to show code</summary>


```lua
local basalt = require("basalt")

local main = basalt.createFrame():setTheme({FrameBG = colors.black, FrameFG = colors.lightGray})

local sub = main:addFrame():setSize(25, 12):setPosition(3, 3)

local function makeResizeable(frame, minW, minH, maxW, maxH)
    minW = minW or 4
    minH = minH or 4
    maxW = maxW or 99
    maxH = maxH or 99
    local btn = frame:addButton()
        :setPosition("parent.w-1", "parent.h-1")
        :setSize(1, 1)
        :setText("/")
        :setForeground(colors.blue)
        :setBackground(colors.black)
        :onDrag(function(self, event, btn, xOffset, yOffset)
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

makeResizeable(sub, 8, 4)

sub:addLabel():setText("Hello World")

basalt.autoUpdate()
```

</details>
<br>
<video width="600" controls autoplay loop muted>
  <source src="./_media/resizable-frames.mp4" type="video/mp4">
</video>

### Scrollable frames

In this example, you will see how to make frames scrollable. Basalt only supports vertical scrolling, but we will also provide an example of how to implement horizontal scrolling.

<details>
<summary>Click here to show code</summary>


```lua
local basalt = require("basalt")

local main = basalt.createFrame():setTheme({FrameBG = colors.black, FrameFG = colors.lightGray})

-- Vertical scrolling is pretty simple, as you can tell:
local sub1 = main:addFrame():setScrollable():setSize(20, 15):setPosition(2, 2)

sub1:addLabel():setPosition(3, 2):setText("Scrollable")
sub1:addLabel():setPosition(3, 12):setText("Inside")
sub1:addLabel():setPosition(3, 20):setText("Outside")

-- Here we create a custom scroll event as you can see we dont add a :setScrollable() method to our frame, instead we add a custom scroll event
local objects = {}

local sub2 = main:addFrame():setPosition(23, 2):setSize(25, 5):onScroll(function(self, event, dir)
    local maxScroll = 0
    for k,v in pairs(objects)do -- here we iterate trough every object and get their x position + width this way we can find out what's the maximum allowed value to scroll
        local x = v:getX()
        local w = v:getWidth()
        maxScroll = x + w > maxScroll and x + w or maxScroll -- if you don't understand this line, http://lua-users.org/wiki/TernaryOperator
    end
    local xOffset = self:getOffset()
    if(xOffset+dir>=0 and xOffset+dir<=maxScroll-self:getWidth())then
        self:setOffset(xOffset+dir, 0)
    end
end)

-- Because we need to iterate the objects, we add them into a table.
table.insert(objects, sub2:addButton():setPosition(2, 2):setText("Scrollable"))
table.insert(objects, sub2:addButton():setPosition(16, 2):setText("Inside"))
table.insert(objects, sub2:addButton():setPosition(30, 2):setText("Outside"))

basalt.autoUpdate()
```

</details>
<br>
<video width="600" controls autoplay loop muted>
  <source src="./_media/scrollable-frames.mp4" type="video/mp4">
</video>
