With animations, you can create a beautiful experience for users while interacting with your program.
There are 2 types of animations, predefined animations and custom animations. By using add and wait you can create custom
animations (calls). Pre-defined methods are for example move, offset, size, changeText,...

:setObject always sets the object on what pre-defined methods should apply on.

When calling a pre-defined animation it will check what is safed as object (:setObject) and will calculate the animation methods based on that which means you won't
be able to change the object on the fly - you will always have to recreate the animation itself


|   |   |
|---|---|
|[add](objects/Animation/add.md)|Adds a new custom function to call at the current time
|[wait](objects/Animation/wait.md)|Adds a amount to the animation time
|[play](objects/Animation/play.md)|Plays the animation
|[cancel](objects/Animation/cancel.md)|Cancels the animation
|[addMode](objects/Animation/addMode.md)|Adds custom easings
|[setMode](objects/Animation/setMode.md)|Changes the current easing-calculation
|[setObject](objects/Animation/setObject.md)|Sets an object on which predefined animations should work on
|[move](objects/Animation/move.md)|Predefined animation: moves the object to a new position
|[offset](objects/Animation/offset.md)|Predefined animation: Changes the offset of that object
|[size](objects/Animation/size.md)|Predefined animation: Changes the size on a object
|[changeText](objects/Animation/changeText.md)|Predefined animation: Changes the text (object needs a setText method)
|[changeTextColor](objects/Animation/changeTextColor.md)|Predefined animation: changes the foreground/textcolor on a object
|[changeBackground](objects/Animation/changeBackground.md)|Predefined animation: changes the background on a object

# Events

|   |   |
|---|---|
|[onStart](objects/Animation/onStart.md)|Gets called as soon as the animation is started
|[onDone](objects/Animation/onDone.md)|Gets called as soon as the animation has finished
