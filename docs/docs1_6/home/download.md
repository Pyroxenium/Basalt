Basalt provides multiple unique versions. A source version, a minified version and a web version.

## Source

This version is, like the name already says, the source code of basalt. If you want to dig into the code, add additional content or just prefer to use the source, then you should aim for the source-version.

The following command allows you to download the source-version on your computer:

`wget run https://basalt.madefor.cc/install.lua source [foldername] [branch]`

The first optional argument is the folder name you wish that basalt should be installed into, by default the folder is called basalt.
The second optional argument is the branch you want to use. If you don't know what this means please ignore it (the 2 options are master and dev)

## Minified / Packed

This version is the minified version, i also call it the packed version. There are 2 changes, the first one is that the code will be shown minified which makes the size much smaller, the second change is that you will recieve a file instead of a folder.

The following command allows you to download the packed-version on your computer:

`wget run https://basalt.madefor.cc/install.lua packed [filename] [branch]`

The first optional argument is the file name you wish that the installer should use, by default the file is called basalt.lua.
The second optional argument is the branch you want to use. If you don't know what this means please ignore it (the 2 options are master and dev)

## Web

The web version is a special version, used if your goal is to keep your project's size as small as possible. I suggest you to use the web version only if you don't restart your program over and over again. For example if you designed your program to reboot after the user made a bad choice (leads into a error or something like that) it is better to use the minified/source version.

The following command allows you to download the web-version on your computer:

`wget run https://basalt.madefor.cc/install.lua web [version] [filename]`

By default the first argument is the latest version of basalt's releases. [Here](https://github.com/Pyroxenium/Basalt/tree/master/docs/versions) you can see which versions are available to use.
For example: wget run https://basalt.madefor.cc/install.lua web basalt-1.6.3.lua - the second argument is just the file name, default is basaltWeb.lua.

Remember to rename `local basalt = require("basalt")` into `local basalt = require("basaltWeb")` if you want to use the web-version