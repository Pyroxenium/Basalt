XML (eXtensible Markup Language) is a popular and widely-used markup language for defining structured data. In this guide, we will explain how to use XML with Basalt to create and manage UI elements and layouts more efficiently.

## Loading an XML File in Basalt

To load an XML file in Basalt, you'll need to use the `container:loadLayout` function. This function reads an XML file and runs any scripts or adds any objects within.

Here's an example of how to load an XML file:

```lua
local basalt = require("basalt")

basalt.createFrame():loadLayout("path/to/your/layout.xml")
```

Make sure that the specified XML file is accessible and located within your project's file system.

## Using XML for Basalt

Basalt uses XML to define UI elements and their properties. By using XML, you can create more organized and easily maintainable UI layouts. Basalt can read and interpret the XML data to create the corresponding UI elements with the specified properties and structure.

Here's an example of an XML file that defines a simple UI layout for Basalt:

```xml
<label text="Welcome to Basalt!" x="10" y="2" />
<button text="OK" x="10" y="5" />
```

In this example, we define a `Label` and a `Button` with their respective properties, such as `id`, `text`, `x`, and `y`.

## Props

Properties, or props for short, allow the layout or object to take parameters as input which can be used in the layout. There are 2 types of props: hard-coded string props and computed props.

Hard-coded string props use the `prop="some text"` syntax. The above example demonstrated this, but by using the computed `prop={some Lua expression}` syntax, these props can be used in a much more powerful way. Anything between the curly braces is evaluated as a Lua expression. For example:

```xml
<label text={"Some text concatenated with a number: " .. 420 * 7 + 9 } />
```

You can pass props to a layout in the form of a table to the `loadLayout` function:

```lua
local basalt = require("basalt")

basalt.createFrame():loadLayout("path/to/your/layout.xml", { buttonText = "Click me!", onClick = function() basalt.log("Testing") end })
```

Props can then be consumed within the layout in the form of the `props` global variable, accessible anywhere within the layout including within computed props.

```xml
<button text={props.buttonText} onClick={props.onClick} />
```

## Scripts

In addition to defining UI elements, you can also include Lua code within your XML files for Basalt. This allows you to perform more complex operations.

To include Lua code in your XML file, you can use the `<script>` tag. Any Lua code enclosed within the `<script>` tag will be executed by Basalt when parsing the XML data. This script shares the global scope with the computed props.

Here's an example of how to include Lua code in your XML file:

```xml
<script>
    if (props.isLoggedIn) then
        labelText = "Logged in!"
    else
        labelText = "Logged out!"
    end
</script>

<label text={labelText} />
```

## Nested layouts

Sometimes a UI gets so complex that it becomes desirable to split it up into several sub-layouts. For this, you can import layouts within a layout:

```xml
<script>
    local basalt = require("basalt")
    AnotherLayout = basalt.layout("path/to/another/layout.xml")
</script>

<label text="Nested layouts are fun" />
<AnotherLayout someProp="Hello" anotherProp="World" aComputedProp={function() return "Basalt rules" end} />
```

This layout can be passed props like any other object in the layout, as seen in the example above.

## Reactivity (BETA)

Reacting to user input is easier than ever with Basalt XML's concept of observable values and observers for said values. This powerful feature allows for properties to be updated automatically from observable values, without needing the programmer to manually call functions to update the object.

To create an observable value, simply use the `basalt.observable(initialValue)` function, which returns getter and setter functions. For example:

```xml
<script>
    local basalt = require("basalt")
    getTimesClicked, setTimesClicked = basalt.observable(0)
</script>
```

You could then hook up this observable value to a property.

```xml
<script>
    local basalt = require("basalt")
    getTimesClicked, setTimesClicked = basalt.observable(0)
</script>

<button text={"Times clicked: " .. getTimesClicked()} />
```

This subscribes the button text to the value of times clicked. If this value is updated via the setter function, the button text will automatically update as well. So let's add an onClick event to do this!

```xml
<script>
    local basalt = require("basalt")
    getTimesClicked, setTimesClicked = basalt.observable(0)
    onClick = function()
        setTimesClicked(getTimesClicked() + 1)
    end
</script>

<button text={"Times clicked: " .. getTimesClicked()} onClick={onClick} />
```

Voila. You now have a button that displays the number of times it's been clicked.

# Effects

In addition to observable values, there are effects that are triggered by them. You can think about it like this: observable values produce updates, while effects detect them and do something in response.

Effects are created using the `basalt.effect(function)` function. Any observable values that are accessed during the effect's execution are automatically subscribed to, and the effect will re-run in response to updates to these values.

For example, you could create an effect that writes a message to the logs whenever the times clicked updates:

```xml
<script>
    local basalt = require("basalt")
    getTimesClicked, setTimesClicked = basalt.observable(0)
    onClick = function()
        setTimesClicked(getTimesClicked() + 1)
    end
    basalt.effect(function()
        basalt.log("Button clicked. New times clicked = " .. getTimesClicked())
    end)
</script>

<button text={"Times clicked: " .. getTimesClicked()} onClick={onClick} />
```

In fact, props are internally implemented using effects! Effects that set the corresponding property in the object to the new observable value.

# Derived values

If observable values are the source of truth, derived values can be thought of as a dependency that uses them and transforms them. Similarly to effects, they also update whenever the observable values they observe update.

To create a derived value, use the `basalt.derived(function)` function, which returns a getter function for the value. Any effect observing this derived value will update if the derived value updates, which itself updates in response to a source observable value updating, in a chain reaction.

The above button example could be rewritten as:

```xml
<script>
    local basalt = require("basalt")
    getTimesClicked, setTimesClicked = basalt.observable(0)
    onClick = function()
        setTimesClicked(getTimesClicked() + 1)
    end
    getButtonText = basalt.derived(function()
        return "Times clicked: " .. getTimesClicked()
    end)
</script>

<button text={getButtonText()} onClick={onClick} />
```

# Untracked observable value access

Sometimes you might want to use a observable value without subscribing to updates. Perhaps you would like a property to be computed based on it only once, never updating afterwards. This can be accomplished using the `basalt.untracked(function)` function:

```xml
<script>
    basalt = require("basalt")
    getTimesClicked, setTimesClicked = basalt.observable(0)
    onClick = function()
        setTimesClicked(getTimesClicked() + 1)
    end
</script>

<button text={"This value should never update: " .. getTimesClicked()} onClick={onClick}/>
```
