The image object is for adding more advanced backgrounds.
It also provides a :shrink() function, where you can shrink the images to smaller ones. This functionallity is fully provided by the blittle library created by Bomb Bloke. I did not ask for permission to add it into the framework. If the creator wants me to remove the blittle part, just text me on discord!

Here are all possible functions available for image:<be>
Remember Image inherits from [Object](objects/Object.md)


## loadImage
loads a image into the memory.
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aImage = mainFrame:addImage("myFirstImage"):loadImage("randomImage.nfp"):show()
```
**Arguments:** string path<br>
**returns:** self<br>


## loadBlittleImage -- not finished yet
loads a blittle image into the memory.
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aImage = mainFrame:addImage("myFirstImage"):loadBlittleImage("blittleImage.blt"):show()
```
**Arguments:** string path<br>
**returns:** self<br>

## shrink
If you were loading a normal (paint) image into the memory, this function would shrink it to a
blittle image and immediatly draws it (if it's visible)
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aImage = mainFrame:addImage("myFirstImage"):loadBlittleImage("randomImage.nfp"):shrink():show()
```
**Arguments:** -<br>
**returns:** self<br>

