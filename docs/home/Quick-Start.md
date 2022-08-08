## HowTo Use

To load the framework into your project, make use of the following code on top of your code.
```lua
local basalt = require("basalt")
```

It does not matter if you have installed the single file version or the full folder project. <br>
Both versions can be loaded by using `require("Basalt")`, you dont need to add `.lua`.

## Download

### Download the folder version
This version is for people who'd like to work with Basalt, change something in Basalt or checkout the project.<br>
But you are also able to just use it to create your own UI.<br>

To install the full project to your CC:Tweaked Computer, use the following command on your CC:Tweaked shell:

`pastebin run ESs1mg7P`

This will download the project as a folder called "Basalt". You are immediatly after the download is done able to use it in your projects.

### Download the single file version
This is the version you should use if you're done with programming. It is a little bit faster and it is also minified, which makes the project smaller.
To install the single filed project to your CC:Tweaked Computer, use the following command on your CC:Tweaked shell:

`pastebin run ESs1mg7P packed`

This will download the project as a single file called "basalt.lua". You are immediatly after the download is done able to use it in your projects.

### Basalt Package Manager

The Basalt Package Manager is still in alpha!<br><br>
The Basalt Package Manager is a visual installer, you are able to change some settings, also to choose which objects are necessary for your projects and which are not. 

To install the BPM (Basalt Package Manager) use the following command on your CC:Tweaked shell:

`pastebin run ESs1mg7P bpm true`

The true keyword in the end is optional and would simply start BPM immediately.

## Example
Here is a fully functioning example of Basalt code

```lua
local basalt = require("basalt") --> Load the Basalt framework

--> Create the first frame. Please note that Basalt needs at least one active "non-parent" frame to properly supply events
--> When Basalt#createFrame makes use of unique identifiers (commonly referred to as UIDs), meaning that the supplied value must be UNIQUE
local mainFrame = basalt.createFrame("mainFrame")

--> Show the frame to the user
mainFrame:show()

local button = mainFrame:addButton("clickableButton") --> Add a button to the mainFrame (With a unique identifier)

--> Set the position of the button, Button#setPosition follows an x, y pattern. 
--> The x value is how far right the object should be from its anchor (negative values from an anchor will travel left)
--> The y value is how far down the object should be from its anchor (negative values from an anchor will travel up)
button:setPosition(4, 4)

button:setText("Click me!") --> Set the text of our button

local function buttonClick() --> This function serves as our click logic 
    basalt.debug("I got clicked!")
end

--> Remember! You cannot supply buttonClick(), that will only supply the result of the function
--> Make sure the button knows which function to call when it's clicked
button:onClick(buttonClick)

button:show() --> Make the button visible, so the user can click it

basalt.autoUpdate() --> Basalt#autoUpdate starts the event listener to detect user input
```
If you're like us and strive for succinct and beautiful code, here is a cleaner implementation of the code above:
```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame("mainFrame"):show()
local button = mainFrame --> Basalt returns an instance of the object on most methods, to make use of "call-chaining"
        :addButton("clickableButton") --> This is an example of call chaining
        :setPosition(4,4) 
        :setText("Click me!")
        :onClick(
            function() 
                basalt.debug("I got clicked!") 
            end)
        :show()

basalt.autoUpdate()
```
