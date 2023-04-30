The VisualObject class is derived from the Object class and serves as the foundation for all visual components in Basalt. Visual objects include elements like frames, buttons, and text boxes. The VisualObject class provides methods for managing the appearance, position, size, and other visual properties of these components.

Here's a list of commonly used methods in the VisualObject class:

|   |   |
|---|---|
|[show](objects/VisualObject/show.md)|Makes the object visible
|[hide](objects/VisualObject/hide.md)|Makes the object invisible
|[setVisible](objects/VisualObject/setVisible.md)|Sets the visibility of the object
|[isVisible](objects/VisualObject/isVisible.md)|Returns the visibility status of the object
|[setPosition](objects/VisualObject/setPosition.md)|Sets the position of the object relative to its parent
|[getPosition](objects/VisualObject/getPosition.md)|Returns the current position of the object
|[getX](objects/VisualObject/getX.md)|Returns the current x-position of the object
|[getY](objects/VisualObject/getY.md)|Returns the current y-position of the object
|[setSize](objects/VisualObject/setSize.md)|Sets the size (width and height) of the object
|[getSize](objects/VisualObject/getSize.md)|Returns the current size of the object
|[getWidth](objects/VisualObject/getWidth.md)|Returns the current width of the object
|[getHeight](objects/VisualObject/getHeight.md)|Returns the current height of the object
|[setBackground](objects/VisualObject/setBackground.md)|Sets the background color of the object
|[getBackground](objects/VisualObject/getBackground.md)|Returns the current background color of the object
|[setForeground](objects/VisualObject/setForeground.md)|Sets the text color of the object
|[getForeground](objects/VisualObject/getForeground.md)|Returns the current text color of the object
|[setTransparency](objects/VisualObject/setTransparency.md)|Sets whether transparency drawings should be used
|[setZIndex](objects/VisualObject/setZIndex.md)|Changes the z-index
|[getAbsolutePosition](objects/VisualObject/getAbsolutePosition.md)|Returns the absolute position of the object
|[ignoreOffset](objects/VisualObject/ignoreOffset.md)|Ignores the parent's offset
|[isFocused](objects/VisualObject/isFocused.md)|Returns whether the object is the focused object
|[setShadow](objects/VisualObject/setShadow.md)|Sets the shadow color for the visual object
|[getShadow](objects/VisualObject/getShadow.md)|Returns the shadow color
|[setBorder](objects/VisualObject/setBorder.md)|Sets the object's border
|[animatePosition](objects/VisualObject/animatePosition.md)|Uses animation to move the object
|[animateSize](objects/VisualObject/animateSize.md)|Uses animation to change the size of the object
|[animateOffset](objects/VisualObject/animateOffset.md)|Uses animation change the offset of the object
|[addTexture](objects/VisualObject/addTexture.md)|Adds a background image texture (nfp or bimg)
|[setTextureMode](objects/VisualObject/setTextureMode.md)|Changes the way the texture gets drawn
|[setInfinitePlay](objects/VisualObject/setInfinitePlay.md)|Activates endless animation play

## Custom drawing

The following list is made for custom draw calls:

|   |   |
|---|---|
|[addDraw](objects/VisualObject/addDraw.md)|Adds a new Draw call
|[addPreDraw](objects/VisualObject/addPreDraw.md)|Adds a new Pre-Draw call
|[addPostDraw](objects/VisualObject/addPostDraw.md)|Adds a new Post-Draw call
|[setDrawState](objects/VisualObject/setDrawState.md)|Changes the draw state of a particular draw call
|[getDrawId](objects/VisualObject/getDrawId.md)|Returns the id of a draw call
|[addText](objects/VisualObject/addText.md)|adds text inside a draw call
|[addBG](objects/VisualObject/addBG.md)|adds background inside a draw call
|[addFG](objects/VisualObject/addFG.md)|adds text color inside a draw call
|[addBlit](objects/VisualObject/addBlit.md)|adds text, bg and tc inside a draw call
|[addTextBox](objects/VisualObject/addTextBox.md)|Adds a text box inside a draw call
|[addBackgroundBox](objects/VisualObject/addBackgroundBox.md)|Adds a background box inside a draw call
|[addForegroundBox](objects/VisualObject/addForegroundBox.md)|Adds a foreground box inside a draw call

## Events

|   |   |
|---|---|
|[onResize](objects/VisualObject/onResize.md)|Triggers when the object is resized
|[onReposition](objects/VisualObject/onReposition.md)|Triggers when the object is repositioned
