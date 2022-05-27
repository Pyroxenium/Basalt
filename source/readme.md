# How to use the source code

The source code is for people who want to change something directly in basalt. You can add/remove objects, add/remove libs or change the drawsystem, eventsystem or whatever you want. For example, you can remove objects you just dont use for a more compact (smaller) basalt. Or you want to create your own objects and add it to the project.

My goal is to make basalt for end users very very easy to use, this is why i want basalt to be in one single file. But this also makes working on it, especially if multiple people working on basalt, very very hard. Because of that i did split the project into multiple file.

## Project

The project folder is the actual source code of basalt. Objects are in project/objects and librariess are in project/lib

## compiler.lua

The compiler will create a basalt.lua file based off of the project's content. It will automatically minify the result. To use the compiler.lua just execute it (make sure the paths are correct, just edit the file and change the absolutepath variable on the top

## loader.lua

The loader file will load the source project into your program, where you can immediately work with the source code instead of always having to compile the code before you can see the changes. Just use local basalt = dofile("source/loader.lua") instead of basalt = dofile("basalt.lua")

## Important

- The source project is still in developement and some things might not work as intended. 
- The minify feature is still not implemented.
- The project folder's content could be completly changed, because i am not fully happy on how it looks like
