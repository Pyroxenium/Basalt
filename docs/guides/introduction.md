Basalt is a powerful and flexible user interface (UI) framework designed to make it easy for developers to create visually appealing and interactive applications. This guide will provide an overview of Basalt, its main components, and the basic concepts and terminology used in the framework.

## What is Basalt?

Basalt is a UI framework that simplifies the process of creating, designing, and managing user interfaces for various applications. It provides a wide range of UI elements and components, such as frames, buttons, labels, text fields, and more, making it easier for developers to create custom and responsive layouts without having to worry about the low-level details of UI rendering and event handling.

## Main Components of Basalt

Basalt consists of several key components that work together to create a seamless user interface experience. Some of the main components include:

1. Objects: Basalt objects represent the various UI elements that make up an application's interface. Examples of objects include frames, buttons, text fields, and more. Each object comes with a set of properties and methods that allow you to customize its appearance and behavior.

2. Frames: Frames are the primary containers for organizing and laying out UI objects in Basalt. They can be nested, allowing for complex and hierarchical layouts. Basalt provides different types of frames, such as basic frames, movable frames, scrollable frames, and flexboxes, each with their own unique properties and use cases.

3. Events: Events are triggered by user interactions, such as clicks, keypresses, and other inputs. Basalt provides an event handling system that allows you to easily respond to these events and update your application's interface or behavior accordingly.

4. Threading: Basalt supports the use of threads in applications, enabling concurrent actions and background processes to run without blocking the main program.

This introduction should give you a basic understanding of Basalt and its main components. As you continue to explore the framework and its features, you'll gain a deeper understanding of how to create and customize your own applications using Basalt.

## Layout Management

Understanding how to manage and organize the layout of UI objects is important when working with Basalt. You can use different types of frames, such as Flexbox or ScrollableFrame, to create responsive and adaptive layouts for your applications.

```lua
local main = basalt.createFrame() -- The main frame/most important frame in your project

local column1 = main:addFrame():setSize("parent.w/2", "parent.h")
local column2 = main:addFrame():setSize("parent.w/2", "parent.h"):setPosition("parent.w/2+1", 1)
```

## Input Handling

Handling user input, such as text input or slider adjustments, is essential for creating interactive applications. Basalt provides various UI elements for capturing user input and events for processing the input.

```lua
local mainFrame = basalt.createFrame()
local aInput = mainFrame:addInput()
aInput:onChange(function(text)
    basalt.debug("User entered: " .. text)
end)
```
