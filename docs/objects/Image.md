The image object is for adding more advanced backgrounds to your interface. It supports the loading of .nfp and .bimg images.

[Object](objects/Object.md) methods also apply for images.

|   |   |
|---|---|
|[loadImage](objects/Image/loadImage.md)|Loads an image from the specified file path
|[setImage](objects/Image/setImage.md)|Set's a new image
|[usePalette](objects/Image/usePalette.md)|Changes the used palette to the image prefered palette
|[play](objects/Image/play.md)|Plays an animated image
|[selectFrame](objects/Image/selectFrame.md)|Selects a specific frame in an animated image
|[getMetadata](objects/Image/getMetadata.md)|Returns the metadata of the image
|[getImageSize](objects/Image/getImageSize.md)|Returns the width and height of the image
|[resizeImage](objects/Image/resizeImage.md)|Resizes the image to the specified dimensions

# About Bimg

Bimg is a custom image format that can be used in place of .nfp, it is a table which can store multiple frames and metadata. The frames can store text, background and foreground, which makes it possible to create any image you'd like. The image format is made by people from the Minecraft Computercraft Mods - Discord. Here's a Github page which explains how the Bimg format works: [bimg](https://github.com/SkyTheCodeMaster/bimg)
