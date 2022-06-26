With input's you are able to create a object where the user can type something in.<br>

Here are all possible functions available for inputs:<br>
Remember Input inherits from [Object](objects/Object.md)

## setInputType
Changes the input type. default: text

#### Parameters: 
1. `string` input type ("text", "password", "number")

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default input and sets it to numbers only.
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aInput = mainFrame:addInput("myFirstInput"):setInputType("number"):show()
```

## getInputType
Gets the current input type

#### Returns:
1. `string` input type

#### Usage:
* Creates a default input and sets it to numbers only. Also prints the current input type to log.
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aInput = mainFrame:addInput("myFirstInput"):setInputType("number"):show()
basalt.debug(aInput:getInputType())
```

## setDefaultText
Sets the default text. This will only be displayed if there is no input set by the user.

#### Parameters: 
1. `string` input type ("text", "password", "number")
2. `number|color` default background color - optional
3. `number|color` default text color - optional

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default input and sets the default text to "...".
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aInput = mainFrame:addInput("myFirstInput"):setInputType("number"):setDefaultText(...):show()
```

## setInputLimit
Sets a character limit to the input.

#### Parameters: 
1. `number` character limit

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default input and sets the character limit to 8.
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aInput = mainFrame:addInput("myFirstInput"):setInputLimit(8):show()
```

## getInputLimit
Returns the input limit.

#### Returns:
1. `number` character limit

#### Usage:
* Creates a default input and sets the character limit to 8. Prints the current limit.
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aInput = mainFrame:addInput("myFirstInput"):setInputLimit(8):show()
basalt.debug(aInput:getInputLimit())
```
