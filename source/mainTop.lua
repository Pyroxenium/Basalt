local basalt = { debugger = true, version = 1 } 
local activeFrame 
local frames = {} 
local keyModifier = {} 
local parentTerminal = term.current()

local sub = string.sub