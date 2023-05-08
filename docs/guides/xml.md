XML (eXtensible Markup Language) is a popular and widely-used markup language for defining structured data. In this guide, we will explain how to use XML with Basalt to create and manage UI elements and layouts more efficiently.

## Loading an XML File in Basalt

To load an XML file in Basalt, you'll need to use the `frame:loadLayout` function. This function reads an XML file and returns a table containing the parsed XML data.

Here's an example of how to load an XML file:

```lua
local basalt = require("basalt")

local main = basalt.createFrame():loadLayout("path/to/your/layout.xml")
```

Make sure that the specified XML file is accessible and located within your project's file system.

## Using XML for Basalt

Basalt uses XML to define UI elements and their properties. By using XML, you can create more organized and easily maintainable UI layouts. Basalt can read and interpret the XML data to create the corresponding UI elements with the specified properties and structure.

Here's an example of an XML file that defines a simple UI layout for Basalt:

```xml
<label id="titleLabel" text="Welcome to Basalt!" x="10" y="2" />
<button id="okButton" text="OK" x="10" y="5" />
```

In this example, we define a `Label` and a `Button` with their respective properties, such as `id`, `text`, `x`, and `y`.

To use the loaded XML data to create the UI elements in Basalt, you can use `main:getXMLElements()`:

```lua
local basalt = require("basalt")

local main = basalt.createFrame():loadLayout("path/to/your/layout.xml")

local uiElements = main:getXMLElements()

local titleLabel = uiElements["titleLabel"]

titleLabel:setText("New Title")
```

## Using Lua Code in XML

In addition to defining UI elements, you can also include Lua code within your XML files for Basalt. This allows you to perform more complex operations or customize your UI elements based on conditions or data.

To include Lua code in your XML file, you can use the `<script>` tag. Any Lua code enclosed within the `<script>` tag will be executed by Basalt when parsing the XML data.

Here's an example of how to include Lua code in your XML file:

```xml
<label id="titleLabel" text="Welcome to Basalt!" x="10" y="2" />
<button id="okButton" text="OK" x="10" y="5" />
<script>
    -- Lua code to change the text of the titleLabel based on a condition
    if someCondition then
        titleLabel:setText("Condition Met!")
    end
</script>
```

To share variables or data between multiple `<script>` tags in your XML file, you can use the global shared table provided by Basalt. This table allows you to store values that can be accessed across different `<script>` tags in your XML file.

Here's an example of using the shared table to share data between two `<script>` tags:

```xml
  <script>
    -- Store a value in the shared table
    shared.myValue = 42
  </script>
  <label id="titleLabel" text="Welcome to Basalt!" x="10" y="2" />
  <button id="okButton" text="OK" x="10" y="5" />
  <script>
    -- Access the stored value from the shared table
    local myValue = shared.myValue

    -- Perform an operation using the shared value, e.g., update titleLabel's text
    titleLabel:setText("Shared Value: " .. myValue)
  </script>
```

In this example, we first store a value in the shared table in one `<script>` tag, and then access that value in another `<script>` tag to update the titleLabel's text.

You can also include Lua code directly within event properties of UI elements. This allows you to execute specific actions or manipulate UI elements when certain events occur.

To include Lua code in an event property, simply add the Lua code within the event property's value in the XML tag. The Lua code will be executed when the specified event is triggered.

```xml
<label id="titleLabel" text="Welcome to Basalt!" x="10" y="2" />
<button id="okButton" text="OK" x="10" y="5" onClick="titleLabel:setText('Button clicked!')" />
```

or

```xml
<label id="titleLabel" text="Welcome to Basalt!" x="10" y="2" />
<button id="okButton" text="OK" x="10" y="5">
    <onClick>
        titleLabel:setText('Button clicked!')
    </onClick>
</button>
```

In both examples, you can see that XML provides a straightforward way to build a Basalt user interface. The XML format allows you to define the UI structure and easily set properties for each UI element, such as position, size, and text.

Notably, you can access UI elements by their assigned ID directly in the event code. In the examples above, the titleLabel and okButton elements are accessed simply by referencing their IDs. This convenient feature eliminates the need to search for or store references to the elements in your code.

Remember: IDs have to be unique!

## Reactive properties (BETA)

Most properties can also be set to track a shared variable using the curly braces {} syntax. In this case, the initial value for the variable should be set inside the `<script>` tag. When this variable is modified, the rendered value will be automatically updated.

The earlier example rewritten using reactive properties:

```xml
<label id="titleLabel" text="Welcome to Basalt!" x="10" y="2" />
<button id="okButton" text={shared.okButtonText} x="10" y="5">
    <onClick>
        shared.okButtonText = "Button clicked!"
    </onClick>
</button>

<script>
  shared.okButtonText = "OK"
</script>
```
