The Image object is designed for adding more advanced backgrounds to your interface. It supports the loading of .nfp and .bimg images, allowing for greater customization of your interface's appearance.

In addition to the Object and VisualObject methods, Image objects have the following methods:

|   |   |
|---|---|
|[loadImage](objects/Image/loadImage.md)|Loads an image from the specified file path
|[setImage](objects/Image/setImage.md)|Set's a new image
|[usePalette](objects/Image/usePalette.md)|Changes the used palette to the image preferred palette
|[play](objects/Image/play.md)|Plays an animated image
|[selectFrame](objects/Image/selectFrame.md)|Selects a specific frame in an animated image
|[getMetadata](objects/Image/getMetadata.md)|Returns the metadata of the image
|[setImageSize](objects/Image/setImageSize.md)|Sets the size of the image
|[getImageSize](objects/Image/getImageSize.md)|Returns the width and height of the image
|[resizeImage](objects/Image/resizeImage.md)|Resizes the image to the specified dimensions
|[setOffset](objects/Image/setOffset.md)|Sets the offset of the image
|[getOffset](objects/Image/getOffset.md)|Returns the offset of the image
|[addFrame](objects/Image/addFrame.md)|Adds a new frame to the image
|[getFrame](objects/Image/getFrame.md)|Returns the specified frame
|[getFrameObject](objects/Image/getFrameObject.md)|Returns the Frame object of the specified frame
|[removeFrame](objects/Image/removeFrame.md)|Removes the specified frame
|[moveFrame](objects/Image/moveFrame.md)|Moves a frame to a new position
|[getFrames](objects/Image/getFrames.md)|Returns all frames of the image
|[getFrameCount](objects/Image/getFrameCount.md)|Returns the number of frames in the image
|[getActiveFrame](objects/Image/getActiveFrame.md)|Returns the currently active frame
|[clear](objects/Image/clear.md)|Clears the image
|[getImage](objects/Image/getImage.md)|Returns the image's data
|[blit](objects/Image/blit.md)|Writes text, foreground and background into the image
|[setText](objects/Image/setText.md)|Writes text into the image
|[setBg](objects/Image/setBg.md)|Writes background color into the image
|[setFg](objects/Image/setFg.md)|Writes text color into the image
|[shrink](objects/Image/shrink.md)|Shrinks the image to a blit version using pixelbox

## About Bimg

Bimg is a custom image format that can be used as an alternative to .nfp. It is a table that can store multiple frames and metadata. The frames can store text, background, and foreground colors, enabling the creation of a wide variety of images. The Bimg format was developed by members of the Minecraft Computercraft Mods Discord community. For more information on the Bimg format, visit the GitHub page: [bimg](https://github.com/SkyTheCodeMaster/bimg)

## Example

Here's an example of how to create and use an Image object:

```lua
-- Create a new Image object
local main = basalt.createFrame()
local myImage = main:addImage()

-- Load an image from a file
myImage:loadImage("/path/to/your/image.nfp")
```

This example demonstrates how to create an Image object, load an image from a file, and display the image on the interface.
