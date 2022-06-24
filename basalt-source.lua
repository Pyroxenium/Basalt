local basalt = { debugger = true, version = 1 } 
local keyActive = {}
local focusedObject
local frames = {}
local activeFrame

local mainFrame
local monFrames = {}

local parentTerminal = term.current()

local sub = string.sub

local tHex = { -- copy paste is a very important feature
    [colors.white] = "0",
    [colors.orange] = "1",
    [colors.magenta] = "2",
    [colors.lightBlue] = "3",
    [colors.yellow] = "4",
    [colors.lime] = "5",
    [colors.pink] = "6",
    [colors.gray] = "7",
    [colors.lightGray] = "8",
    [colors.cyan] = "9",
    [colors.purple] = "a",
    [colors.blue] = "b",
    [colors.brown] = "c",
    [colors.green] = "d",
    [colors.red] = "e",
    [colors.black] = "f",
}
-- current version 1
local theme = {
    basaltBG = colors.lightGray,
    basaltFG = colors.black,
    FrameBG = colors.gray,
    FrameFG = colors.black,
    ButtonBG = colors.gray,
    ButtonFG = colors.black,
    CheckboxBG = colors.gray,
    CheckboxFG = colors.black,
    InputBG = colors.gray,
    InputFG = colors.black,
    textfieldBG = colors.gray,
    textfieldFG = colors.black,
    listBG = colors.gray,
    listFG = colors.black,
    dropdownBG = colors.gray,
    dropdownFG = colors.black,
    radioBG = colors.gray,
    radioFG = colors.black,
    selectionBG = colors.black,
    selectionFG = colors.lightGray,
}
-------------------------------------------------------------------------------------
-- Wojbies API 5.0 - Bigfont - functions to write bigger font using drawing sybols --
-------------------------------------------------------------------------------------
--   Copyright (c) 2015-2022 Wojbie (wojbie@wojbie.net)
--   Redistribution and use in source and binary forms, with or without modification, are permitted (subject to the limitations in the disclaimer below) provided that the following conditions are met:
--   1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
--   2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
--   3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
--   4. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
--   5. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
--   NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS ARE GRANTED BY THIS LICENSE. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. YOU ACKNOWLEDGE THAT THIS SOFTWARE IS NOT DESIGNED, LICENSED OR INTENDED FOR USE IN THE DESIGN, CONSTRUCTION, OPERATION OR MAINTENANCE OF ANY NUCLEAR FACILITY.

local rawFont = {{"\32\32\32\137\156\148\158\159\148\135\135\144\159\139\32\136\157\32\159\139\32\32\143\32\32\143\32\32\32\32\32\32\32\32\147\148\150\131\148\32\32\32\151\140\148\151\140\147", "\32\32\32\149\132\149\136\156\149\144\32\133\139\159\129\143\159\133\143\159\133\138\32\133\138\32\133\32\32\32\32\32\32\150\150\129\137\156\129\32\32\32\133\131\129\133\131\132", "\32\32\32\130\131\32\130\131\32\32\129\32\32\32\32\130\131\32\130\131\32\32\32\32\143\143\143\32\32\32\32\32\32\130\129\32\130\135\32\32\32\32\131\32\32\131\32\131", "\139\144\32\32\143\148\135\130\144\149\32\149\150\151\149\158\140\129\32\32\32\135\130\144\135\130\144\32\149\32\32\139\32\159\148\32\32\32\32\159\32\144\32\148\32\147\131\132", "\159\135\129\131\143\149\143\138\144\138\32\133\130\149\149\137\155\149\159\143\144\147\130\132\32\149\32\147\130\132\131\159\129\139\151\129\148\32\32\139\131\135\133\32\144\130\151\32", "\32\32\32\32\32\32\130\135\32\130\32\129\32\129\129\131\131\32\130\131\129\140\141\132\32\129\32\32\129\32\32\32\32\32\32\32\131\131\129\32\32\32\32\32\32\32\32\32", "\32\32\32\32\149\32\159\154\133\133\133\144\152\141\132\133\151\129\136\153\32\32\154\32\159\134\129\130\137\144\159\32\144\32\148\32\32\32\32\32\32\32\32\32\32\32\151\129", "\32\32\32\32\133\32\32\32\32\145\145\132\141\140\132\151\129\144\150\146\129\32\32\32\138\144\32\32\159\133\136\131\132\131\151\129\32\144\32\131\131\129\32\144\32\151\129\32", "\32\32\32\32\129\32\32\32\32\130\130\32\32\129\32\129\32\129\130\129\129\32\32\32\32\130\129\130\129\32\32\32\32\32\32\32\32\133\32\32\32\32\32\129\32\129\32\32", "\150\156\148\136\149\32\134\131\148\134\131\148\159\134\149\136\140\129\152\131\32\135\131\149\150\131\148\150\131\148\32\148\32\32\148\32\32\152\129\143\143\144\130\155\32\134\131\148", "\157\129\149\32\149\32\152\131\144\144\131\148\141\140\149\144\32\149\151\131\148\32\150\32\150\131\148\130\156\133\32\144\32\32\144\32\130\155\32\143\143\144\32\152\129\32\134\32", "\130\131\32\131\131\129\131\131\129\130\131\32\32\32\129\130\131\32\130\131\32\32\129\32\130\131\32\130\129\32\32\129\32\32\133\32\32\32\129\32\32\32\130\32\32\32\129\32", "\150\140\150\137\140\148\136\140\132\150\131\132\151\131\148\136\147\129\136\147\129\150\156\145\138\143\149\130\151\32\32\32\149\138\152\129\149\32\32\157\152\149\157\144\149\150\131\148", "\149\143\142\149\32\149\149\32\149\149\32\144\149\32\149\149\32\32\149\32\32\149\32\149\149\32\149\32\149\32\144\32\149\149\130\148\149\32\32\149\32\149\149\130\149\149\32\149", "\130\131\129\129\32\129\131\131\32\130\131\32\131\131\32\131\131\129\129\32\32\130\131\32\129\32\129\130\131\32\130\131\32\129\32\129\131\131\129\129\32\129\129\32\129\130\131\32", "\136\140\132\150\131\148\136\140\132\153\140\129\131\151\129\149\32\149\149\32\149\149\32\149\137\152\129\137\152\129\131\156\133\149\131\32\150\32\32\130\148\32\152\137\144\32\32\32", "\149\32\32\149\159\133\149\32\149\144\32\149\32\149\32\149\32\149\150\151\129\138\155\149\150\130\148\32\149\32\152\129\32\149\32\32\32\150\32\32\149\32\32\32\32\32\32\32", "\129\32\32\130\129\129\129\32\129\130\131\32\32\129\32\130\131\32\32\129\32\129\32\129\129\32\129\32\129\32\131\131\129\130\131\32\32\32\129\130\131\32\32\32\32\140\140\132", "\32\154\32\159\143\32\149\143\32\159\143\32\159\144\149\159\143\32\159\137\145\159\143\144\149\143\32\32\145\32\32\32\145\149\32\144\32\149\32\143\159\32\143\143\32\159\143\32", "\32\32\32\152\140\149\151\32\149\149\32\145\149\130\149\157\140\133\32\149\32\154\143\149\151\32\149\32\149\32\144\32\149\149\153\32\32\149\32\149\133\149\149\32\149\149\32\149", "\32\32\32\130\131\129\131\131\32\130\131\32\130\131\129\130\131\129\32\129\32\140\140\129\129\32\129\32\129\32\137\140\129\130\32\129\32\130\32\129\32\129\129\32\129\130\131\32", "\144\143\32\159\144\144\144\143\32\159\143\144\159\138\32\144\32\144\144\32\144\144\32\144\144\32\144\144\32\144\143\143\144\32\150\129\32\149\32\130\150\32\134\137\134\134\131\148", "\136\143\133\154\141\149\151\32\129\137\140\144\32\149\32\149\32\149\154\159\133\149\148\149\157\153\32\154\143\149\159\134\32\130\148\32\32\149\32\32\151\129\32\32\32\32\134\32", "\133\32\32\32\32\133\129\32\32\131\131\32\32\130\32\130\131\129\32\129\32\130\131\129\129\32\129\140\140\129\131\131\129\32\130\129\32\129\32\130\129\32\32\32\32\32\129\32", "\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32", "\32\32\32\32\32\32\32\32\32\32\32\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\32\32\32\32\32\32\32\32\32\32\32", "\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32", "\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32", "\32\32\32\32\32\32\32\32\32\32\32\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\32\32\32\32\32\32\32\32\32\32\32", "\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32", "\32\32\32\32\145\32\159\139\32\151\131\132\155\143\132\134\135\145\32\149\32\158\140\129\130\130\32\152\147\155\157\134\32\32\144\144\32\32\32\32\32\32\152\131\155\131\131\129", "\32\32\32\32\149\32\149\32\145\148\131\32\149\32\149\140\157\132\32\148\32\137\155\149\32\32\32\149\154\149\137\142\32\153\153\32\131\131\149\131\131\129\149\135\145\32\32\32", "\32\32\32\32\129\32\130\135\32\131\131\129\134\131\132\32\129\32\32\129\32\131\131\32\32\32\32\130\131\129\32\32\32\32\129\129\32\32\32\32\32\32\130\131\129\32\32\32", "\150\150\32\32\148\32\134\32\32\132\32\32\134\32\32\144\32\144\150\151\149\32\32\32\32\32\32\145\32\32\152\140\144\144\144\32\133\151\129\133\151\129\132\151\129\32\145\32", "\130\129\32\131\151\129\141\32\32\142\32\32\32\32\32\149\32\149\130\149\149\32\143\32\32\32\32\142\132\32\154\143\133\157\153\132\151\150\148\151\158\132\151\150\148\144\130\148", "\32\32\32\140\140\132\32\32\32\32\32\32\32\32\32\151\131\32\32\129\129\32\32\32\32\134\32\32\32\32\32\32\32\129\129\32\129\32\129\129\130\129\129\32\129\130\131\32", "\156\143\32\159\141\129\153\140\132\153\137\32\157\141\32\159\142\32\150\151\129\150\131\132\140\143\144\143\141\145\137\140\148\141\141\144\157\142\32\159\140\32\151\134\32\157\141\32", "\157\140\149\157\140\149\157\140\149\157\140\149\157\140\149\157\140\149\151\151\32\154\143\132\157\140\32\157\140\32\157\140\32\157\140\32\32\149\32\32\149\32\32\149\32\32\149\32", "\129\32\129\129\32\129\129\32\129\129\32\129\129\32\129\129\32\129\129\131\129\32\134\32\131\131\129\131\131\129\131\131\129\131\131\129\130\131\32\130\131\32\130\131\32\130\131\32", "\151\131\148\152\137\145\155\140\144\152\142\145\153\140\132\153\137\32\154\142\144\155\159\132\150\156\148\147\32\144\144\130\145\136\137\32\146\130\144\144\130\145\130\136\32\151\140\132", "\151\32\149\151\155\149\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\152\137\144\157\129\149\149\32\149\149\32\149\149\32\149\149\32\149\130\150\32\32\157\129\149\32\149", "\131\131\32\129\32\129\130\131\32\130\131\32\130\131\32\130\131\32\130\131\32\32\32\32\130\131\32\130\131\32\130\131\32\130\131\32\130\131\32\32\129\32\130\131\32\133\131\32", "\156\143\32\159\141\129\153\140\132\153\137\32\157\141\32\159\142\32\159\159\144\152\140\144\156\143\32\159\141\129\153\140\132\157\141\32\130\145\32\32\147\32\136\153\32\130\146\32", "\152\140\149\152\140\149\152\140\149\152\140\149\152\140\149\152\140\149\149\157\134\154\143\132\157\140\133\157\140\133\157\140\133\157\140\133\32\149\32\32\149\32\32\149\32\32\149\32", "\130\131\129\130\131\129\130\131\129\130\131\129\130\131\129\130\131\129\130\130\131\32\134\32\130\131\129\130\131\129\130\131\129\130\131\129\32\129\32\32\129\32\32\129\32\32\129\32", "\159\134\144\137\137\32\156\143\32\159\141\129\153\140\132\153\137\32\157\141\32\32\132\32\159\143\32\147\32\144\144\130\145\136\137\32\146\130\144\144\130\145\130\138\32\146\130\144", "\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\131\147\129\138\134\149\149\32\149\149\32\149\149\32\149\149\32\149\154\143\149\32\157\129\154\143\149", "\130\131\32\129\32\129\130\131\32\130\131\32\130\131\32\130\131\32\130\131\32\32\32\32\130\131\32\130\131\129\130\131\129\130\131\129\130\131\129\140\140\129\130\131\32\140\140\129" }, {[[000110000110110000110010101000000010000000100101]], [[000000110110000000000010101000000010000000100101]], [[000000000000000000000000000000000000000000000000]], [[100010110100000010000110110000010100000100000110]], [[000000110000000010110110000110000000000000110000]], [[000000000000000000000000000000000000000000000000]], [[000000110110000010000000100000100000000000000010]], [[000000000110110100010000000010000000000000000100]], [[000000000000000000000000000000000000000000000000]], [[010000000000100110000000000000000000000110010000]], [[000000000000000000000000000010000000010110000000]], [[000000000000000000000000000000000000000000000000]], [[011110110000000100100010110000000100000000000000]], [[000000000000000000000000000000000000000000000000]], [[000000000000000000000000000000000000000000000000]], [[110000110110000000000000000000010100100010000000]], [[000010000000000000110110000000000100010010000000]], [[000000000000000000000000000000000000000000000000]], [[010110010110100110110110010000000100000110110110]], [[000000000000000000000110000000000110000000000000]], [[000000000000000000000000000000000000000000000000]], [[010100010110110000000000000000110000000010000000]], [[110110000000000000110000110110100000000010000000]], [[000000000000000000000000000000000000000000000000]], [[000100011111000100011111000100011111000100011111]], [[000000000000100100100100011011011011111111111111]], [[000000000000000000000000000000000000000000000000]], [[000100011111000100011111000100011111000100011111]], [[000000000000100100100100011011011011111111111111]], [[100100100100100100100100100100100100100100100100]], [[000000110100110110000010000011110000000000011000]], [[000000000100000000000010000011000110000000001000]], [[000000000000000000000000000000000000000000000000]], [[010000100100000000000000000100000000010010110000]], [[000000000000000000000000000000110110110110110000]], [[000000000000000000000000000000000000000000000000]], [[110110110110110110000000110110110110110110110110]], [[000000000000000000000110000000000000000000000000]], [[000000000000000000000000000000000000000000000000]], [[000000000000110110000110010000000000000000010010]], [[000010000000000000000000000000000000000000000000]], [[000000000000000000000000000000000000000000000000]], [[110110110110110110110000110110110110000000000000]], [[000000000000000000000110000000000000000000000000]], [[000000000000000000000000000000000000000000000000]], [[110110110110110110110000110000000000000000010000]], [[000000000000000000000000100000000000000110000110]], [[000000000000000000000000000000000000000000000000]] }}

--### Genarate fonts using 3x3 chars per a character. (1 character is 6x9 pixels)
local fonts = {}
local firstFont = {}
do
    local char = 0
    local height = #rawFont[1]
    local length = #rawFont[1][1]
    for i = 1, height, 3 do
        for j = 1, length, 3 do
            local thisChar = string.char(char)

            local temp = {}
            temp[1] = rawFont[1][i]:sub(j, j + 2)
            temp[2] = rawFont[1][i + 1]:sub(j, j + 2)
            temp[3] = rawFont[1][i + 2]:sub(j, j + 2)

            local temp2 = {}
            temp2[1] = rawFont[2][i]:sub(j, j + 2)
            temp2[2] = rawFont[2][i + 1]:sub(j, j + 2)
            temp2[3] = rawFont[2][i + 2]:sub(j, j + 2)

            firstFont[thisChar] = {temp, temp2}
            char = char + 1
        end
    end
    fonts[1] = firstFont
end

local function generateFontSize(size,yeld)
    local inverter = {["0"] = "1", ["1"] = "0"} --:gsub("[01]",inverter)
    if size<= #fonts then return true end
    for f = #fonts+1, size do
        --automagicly make bigger fonts using firstFont and fonts[f-1].
        local nextFont = {}
        local lastFont = fonts[f - 1]
        for char = 0, 255 do
            local thisChar = string.char(char)
            --sleep(0) print(f,thisChar)

            local temp = {}
            local temp2 = {}

            local templateChar = lastFont[thisChar][1]
            local templateBack = lastFont[thisChar][2]
            for i = 1, #templateChar do
                local line1, line2, line3, back1, back2, back3 = {}, {}, {}, {}, {}, {}
                for j = 1, #templateChar[1] do
                    local currentChar = firstFont[templateChar[i]:sub(j, j)][1]
                    table.insert(line1, currentChar[1])
                    table.insert(line2, currentChar[2])
                    table.insert(line3, currentChar[3])

                    local currentBack = firstFont[templateChar[i]:sub(j, j)][2]
                    if templateBack[i]:sub(j, j) == "1" then
                        table.insert(back1, (currentBack[1]:gsub("[01]", inverter)))
                        table.insert(back2, (currentBack[2]:gsub("[01]", inverter)))
                        table.insert(back3, (currentBack[3]:gsub("[01]", inverter)))
                    else
                        table.insert(back1, currentBack[1])
                        table.insert(back2, currentBack[2])
                        table.insert(back3, currentBack[3])
                    end
                end
                table.insert(temp, table.concat(line1))
                table.insert(temp, table.concat(line2))
                table.insert(temp, table.concat(line3))
                table.insert(temp2, table.concat(back1))
                table.insert(temp2, table.concat(back2))
                table.insert(temp2, table.concat(back3))
            end

            nextFont[thisChar] = {temp, temp2}
            if yeld then yeld = "Font"..f.."Yeld"..char os.queueEvent(yeld) os.pullEvent(yeld) end
        end
        fonts[f] = nextFont
    end
    return true
end

local function makeText(nSize, sString, nFC, nBC, bBlit)
    if not type(sString) == "string" then error("Not a String",3) end --this should never happend with expects in place.
    local cFC = type(nFC) == "string" and nFC:sub(1, 1) or tHex[nFC] or error("Wrong Front Color",3)
    local cBC = type(nBC) == "string" and nBC:sub(1, 1) or tHex[nBC] or error("Wrong Back Color",3)
    if(fonts[nSize]==nil)then generateFontSize(3,false) end
    local font = fonts[nSize] or error("Wrong font size selected",3)
    if sString == "" then return {{""}, {""}, {""}} end
    
    local input = {}
    for i in sString:gmatch('.') do table.insert(input, i) end

    local tText = {}
    local height = #font[input[1]][1]


    for nLine = 1, height do
        local outLine = {}
        for i = 1, #input do
            outLine[i] = font[input[i]] and font[input[i]][1][nLine] or ""
        end
        tText[nLine] = table.concat(outLine)
    end

    local tFront = {}
    local tBack = {}
    local tFrontSub = {["0"] = cFC, ["1"] = cBC}
    local tBackSub = {["0"] = cBC, ["1"] = cFC}

    for nLine = 1, height do
        local front = {}
        local back = {}
        for i = 1, #input do
            local template = font[input[i]] and font[input[i]][2][nLine] or ""
            front[i] = template:gsub("[01]", bBlit and {["0"] = nFC:sub(i, i), ["1"] = nBC:sub(i, i)} or tFrontSub)
            back[i] = template:gsub("[01]", bBlit and {["0"] = nBC:sub(i, i), ["1"] = nFC:sub(i, i)} or tBackSub)
        end
        tFront[nLine] = table.concat(front)
        tBack[nLine] = table.concat(back)
    end

    return {tText, tFront, tBack}
end
local function basaltDrawHelper(drawTerm)
    local terminal = drawTerm
    local width, height = terminal.getSize()
    local cacheT = {}
    local cacheBG = {}
    local cacheFG = {}

    local _cacheT = {}
    local _cacheBG = {}
    local _cacheFG = {}

    local emptySpaceLine
    local emptyColorLines = {}

    local function createEmptyLines()
        emptySpaceLine = (" "):rep(width)
        for n = 0, 15 do
            local nColor = 2 ^ n
            local sHex = tHex[nColor]
            emptyColorLines[nColor] = sHex:rep(width)
        end
    end
    ----
    createEmptyLines()

    local function recreateWindowArray()
        local emptyText = emptySpaceLine
        local emptyFG = emptyColorLines[colors.white]
        local emptyBG = emptyColorLines[colors.black]
        for currentY = 1, height do
            cacheT[currentY] = sub(cacheT[currentY] == nil and emptyText or cacheT[currentY] .. emptyText:sub(1, width - cacheT[currentY]:len()), 1, width)
            cacheFG[currentY] = sub(cacheFG[currentY] == nil and emptyFG or cacheFG[currentY] .. emptyFG:sub(1, width - cacheFG[currentY]:len()), 1, width)
            cacheBG[currentY] = sub(cacheBG[currentY] == nil and emptyBG or cacheBG[currentY] .. emptyBG:sub(1, width - cacheBG[currentY]:len()), 1, width)
        end
    end
    recreateWindowArray()

    local function setText(x, y, text)
        if (y >= 1) and (y <= height) then
            if (x + text:len() > 0) and (x <= width) then
                local oldCache = cacheT[y]
                local newCache
                local nEnd = x + #text - 1

                if (x < 1) then
                    local startN = 1 - x + 1
                    local endN = width - x + 1
                    text = sub(text, startN, endN)
                elseif (nEnd > width) then
                    local endN = width - x + 1
                    text = sub(text, 1, endN)
                end

                if (x > 1) then
                    local endN = x - 1
                    newCache = sub(oldCache, 1, endN) .. text
                else
                    newCache = text
                end
                if nEnd < width then
                    newCache = newCache .. sub(oldCache, nEnd + 1, width)
                end
                cacheT[y] = newCache
            end
        end
    end

    local function setBG(x, y, colorStr)
        if (y >= 1) and (y <= height) then
            if (x + colorStr:len() > 0) and (x <= width) then
                local oldCache = cacheBG[y]
                local newCache
                local nEnd = x + #colorStr - 1

                if (x < 1) then
                    colorStr = sub(colorStr, 1 - x + 1, width - x + 1)
                elseif (nEnd > width) then
                    colorStr = sub(colorStr, 1, width - x + 1)
                end

                if (x > 1) then
                    newCache = sub(oldCache, 1, x - 1) .. colorStr
                else
                    newCache = colorStr
                end
                if nEnd < width then
                    newCache = newCache .. sub(oldCache, nEnd + 1, width)
                end
                cacheBG[y] = newCache
            end
        end
    end

    local function setFG(x, y, colorStr)
        if (y >= 1) and (y <= height) then
            if (x + colorStr:len() > 0) and (x <= width) then
                local oldCache = cacheFG[y]
                local newCache
                local nEnd = x + #colorStr - 1

                if (x < 1) then
                    local startN = 1 - x + 1
                    local endN = width - x + 1
                    colorStr = sub(colorStr, startN, endN)
                elseif (nEnd > width) then
                    local endN = width - x + 1
                    colorStr = sub(colorStr, 1, endN)
                end

                if (x > 1) then
                    local endN = x - 1
                    newCache = sub(oldCache, 1, endN) .. colorStr
                else
                    newCache = colorStr
                end
                if nEnd < width then
                    newCache = newCache .. sub(oldCache, nEnd + 1, width)
                end
                cacheFG[y] = newCache
            end
        end
    end

    local drawHelper = {
        setBG = function(x, y, colorStr)
            setBG(x, y, colorStr)
        end;

        setText = function(x, y, text)
            setText(x, y, text)
        end;

        setFG = function(x, y, colorStr)
            setFG(x, y, colorStr)
        end;

        drawBackgroundBox = function(x, y, width, height, bgCol)
            for n = 1, height do
                setBG(x, y + (n - 1), tHex[bgCol]:rep(width))
            end
        end;
        drawForegroundBox = function(x, y, width, height, fgCol)
            for n = 1, height do
                setFG(x, y + (n - 1), tHex[fgCol]:rep(width))
            end
        end;
        drawTextBox = function(x, y, width, height, symbol)
            for n = 1, height do
                setText(x, y + (n - 1), symbol:rep(width))
            end
        end;
        writeText = function(x, y, text, bgCol, fgCol)
            bgCol = bgCol or terminal.getBackgroundColor()
            fgCol = fgCol or terminal.getTextColor()
            setText(x, y, text)
            setBG(x, y, tHex[bgCol]:rep(text:len()))
            setFG(x, y, tHex[fgCol]:rep(text:len()))
        end;

        update = function()
            local xC, yC = terminal.getCursorPos()
            local isBlinking = false
            if (terminal.getCursorBlink ~= nil) then
                isBlinking = terminal.getCursorBlink()
            end
            terminal.setCursorBlink(false)
            for n = 1, height do
                terminal.setCursorPos(1, n)
                terminal.blit(cacheT[n], cacheFG[n], cacheBG[n])
            end
            terminal.setBackgroundColor(colors.black)
            terminal.setCursorBlink(isBlinking)
            terminal.setCursorPos(xC, yC)
        end;

        setTerm = function(newTerm)
            terminal = newTerm;
        end;
    }
    return drawHelper
end
local function BasaltEvents()

    local events = {}
    local index = {}

    local event = {
        registerEvent = function(self, _event, func)
            if (events[_event] == nil) then
                events[_event] = {}
                index[_event] = 1
            end
            events[_event][index[_event]] = func
            index[_event] = index[_event] + 1
            return index[_event] - 1
        end;

        removeEvent = function(self, _event, index)
            events[_event][index[_event]] = nil
        end;

        sendEvent = function(self, _event, ...)
            local returnValue
            if (events[_event] ~= nil) then
                for _, value in pairs(events[_event]) do
                    local val = value(...)
                    if(val==false)then
                        returnValue = val
                    end
                end
            end
            return returnValue
        end;
    }
    event.__index = event
    return event
end
local eventSystem = BasaltEvents()
local processes = {}
local process = {}
local processId = 0

function process:new(path, window, ...)
    local args = table.pack(...)
    local newP = setmetatable({ path = path }, { __index = self })
    newP.window = window
    newP.processId = processId
    newP.coroutine = coroutine.create(function()
        os.run({ }, path, table.unpack(args))
    end)
    processes[processId] = newP
    processId = processId + 1
    return newP
end

function process:resume(event, ...)
    term.redirect(self.window)
    local ok, result = coroutine.resume(self.coroutine, event, ...)
    self.window = term.current()
    if ok then
        self.filter = result
    else
        basalt.debug(result)
    end
end

function process:isDead()
    if (self.coroutine ~= nil) then
        if (coroutine.status(self.coroutine) == "dead") then
            table.remove(processes, self.processId)
            return true
        end
    else
        return true
    end
    return false
end

function process:getStatus()
    if (self.coroutine ~= nil) then
        return coroutine.status(self.coroutine)
    end
    return nil
end

function process:start()
    coroutine.resume(self.coroutine)
end
local function getTextHorizontalAlign(text, width, textAlign, replaceChar)
    text = string.sub(text, 1, width)
    local offset = width - string.len(text)
    if (textAlign == "right") then
        text = string.rep(replaceChar or " ", offset) .. text
    elseif (textAlign == "center") then
        text = string.rep(replaceChar or " ", math.floor(offset / 2)) .. text .. string.rep(replaceChar or " ", math.floor(offset / 2))
        text = text .. (string.len(text) < width and (replaceChar or " ") or "")
    else
        text = text .. string.rep(replaceChar or " ", offset)
    end
    return text
end

local function getTextVerticalAlign(h, textAlign)
    local offset = 0
    if (textAlign == "center") then
        offset = math.ceil(h / 2)
        if (offset < 1) then
            offset = 1
        end
    end
    if (textAlign == "bottom") then
        offset = h
    end
    if(offset<1)then offset=1 end
    return offset
end

local function rpairs(t)
    return function(t, i)
        i = i - 1
        if i ~= 0 then
            return i, t[i]
        end
    end, t, #t + 1
end

-- shrink system is copy pasted (and slightly changed) from blittle by Bomb Bloke: http://www.computercraft.info/forums2/index.php?/topic/25354-cc-176-blittle-api/
local function shrink(bLittleData, bgColor)
    local relations = { [0] = { 8, 4, 3, 6, 5 }, { 4, 14, 8, 7 }, { 6, 10, 8, 7 }, { 9, 11, 8, 0 }, { 1, 14, 8, 0 }, { 13, 12, 8, 0 }, { 2, 10, 8, 0 }, { 15, 8, 10, 11, 12, 14 },
                        { 0, 7, 1, 9, 2, 13 }, { 3, 11, 8, 7 }, { 2, 6, 7, 15 }, { 9, 3, 7, 15 }, { 13, 5, 7, 15 }, { 5, 12, 8, 7 }, { 1, 4, 7, 15 }, { 7, 10, 11, 12, 14 } }

    local colourNum, exponents, colourChar = {}, {}, {}
    for i = 0, 15 do
        exponents[2 ^ i] = i
    end
    do
        local hex = "0123456789abcdef"
        for i = 1, 16 do
            colourNum[hex:sub(i, i)] = i - 1
            colourNum[i - 1] = hex:sub(i, i)
            colourChar[hex:sub(i, i)] = 2 ^ (i - 1)
            colourChar[2 ^ (i - 1)] = hex:sub(i, i)

            local thisRel = relations[i - 1]
            for i = 1, #thisRel do
                thisRel[i] = 2 ^ thisRel[i]
            end
        end
    end

    local function getBestColourMatch(usage)
        local lastCol = relations[exponents[usage[#usage][1]]]
        if(lastCol~=nil)then
            for j = 1, #lastCol do
                local thisRelation = lastCol[j]
                for i = 1, #usage - 1 do
                    if usage[i][1] == thisRelation then
                        return i
                    end
                end
            end
        end
        return 1
    end

    local function colsToChar(pattern, totals)
        if not totals then
            local newPattern = {}
            totals = {}
            for i = 1, 6 do
                local thisVal = pattern[i]
                local thisTot = totals[thisVal]
                totals[thisVal], newPattern[i] = thisTot and (thisTot + 1) or 1, thisVal
            end
            pattern = newPattern
        end

        local usage = {}
        for key, value in pairs(totals) do
            usage[#usage + 1] = { key, value }
        end

        if #usage > 1 then
            -- Reduce the chunk to two colours:
            while #usage > 2 do
                table.sort(usage, function(a, b)
                    return a[2] > b[2]
                end)
                local matchToInd, usageLen = getBestColourMatch(usage), #usage
                local matchFrom, matchTo = usage[usageLen][1], usage[matchToInd][1]
                for i = 1, 6 do
                    if pattern[i] == matchFrom then
                        pattern[i] = matchTo
                        usage[matchToInd][2] = usage[matchToInd][2] + 1
                    end
                end
                usage[usageLen] = nil
            end

            -- Convert to character. Adapted from oli414's function:
            -- http://www.computercraft.info/forums2/index.php?/topic/25340-cc-176-easy-drawing-characters/
            local data = 128
            for i = 1, #pattern - 1 do
                if pattern[i] ~= pattern[6] then
                    data = data + 2 ^ (i - 1)
                end
            end
            return string.char(data), colourChar[usage[1][1] == pattern[6] and usage[2][1] or usage[1][1]], colourChar[pattern[6]]
        else
            -- Solid colour character:
            return "\128", colourChar[pattern[1]], colourChar[pattern[1]]
        end
    end

    local results, width, height, bgCol = { {}, {}, {} }, 0, #bLittleData + #bLittleData % 3, bgColor or colors.black
    for i = 1, #bLittleData do
        if #bLittleData[i] > width then
            width = #bLittleData[i]
        end
    end

    for y = 0, height - 1, 3 do
        local cRow, tRow, bRow, counter = {}, {}, {}, 1

        for x = 0, width - 1, 2 do
            -- Grab a 2x3 chunk:
            local pattern, totals = {}, {}

            for yy = 1, 3 do
                for xx = 1, 2 do
                    pattern[#pattern + 1] = (bLittleData[y + yy] and bLittleData[y + yy][x + xx]) and (bLittleData[y + yy][x + xx] == 0 and bgCol or bLittleData[y + yy][x + xx]) or bgCol
                    totals[pattern[#pattern]] = totals[pattern[#pattern]] and (totals[pattern[#pattern]] + 1) or 1
                end
            end

            cRow[counter], tRow[counter], bRow[counter] = colsToChar(pattern, totals)
            counter = counter + 1
        end

        results[1][#results[1] + 1], results[2][#results[2] + 1], results[3][#results[3] + 1] = table.concat(cRow), table.concat(tRow), table.concat(bRow)
    end

    results.width, results.height = #results[1][1], #results[1]

    return results
end
local function Object(name)
    -- Base object
    local objectType = "Object" -- not changeable
    local value
    local zIndex = 1
    local anchor = "topLeft"
    local ignOffset = false
    local isVisible = false

    local shadow = false
    local borderLeft = false
    local borderTop = false
    local borderRight = false
    local borderBottom = false

    local shadowColor = colors.black
    local borderColor = colors.black

    local visualsChanged = true

    local eventSystem = BasaltEvents()

    local object = {
        x = 1,
        y = 1,
        width = 1,
        height = 1,
        bgColor = colors.black,
        fgColor = colors.white,
        name = name or "Object",
        parent = nil,

        show = function(self)
            isVisible = true
            visualsChanged = true
            return self
        end;

        hide = function(self)
            isVisible = false
            visualsChanged = true
            return self
        end;

        isVisible = function(self)
            return isVisible
        end;

        setFocus = function(self)
            if (self.parent ~= nil) then
                self.parent:setFocusedObject(self)
            end
            return self
        end;

        setZIndex = function(self, index)
            zIndex = index
            if (self.parent ~= nil) then
                self.parent:removeObject(self)
                self.parent:addObject(self)
            end
            return self
        end;

        getZIndex = function(self)
            return zIndex;
        end;

        getType = function(self)
            return objectType
        end;

        getName = function(self)
            return self.name
        end;

        remove = function(self)
            if (self.parent ~= nil) then
                self.parent:removeObject(self)
            end
            return self
        end;

        setParent = function(self, frame)
            if (frame.getType ~= nil and frame:getType() == "Frame") then
                self:remove()
                frame:addObject(self)
                if (self.draw) then
                    self:show()
                end
            end
            return self
        end;

        setValue = function(self, _value)
            if (value ~= _value) then
                value = _value
                visualsChanged = true
                self:valueChangedHandler()
            end
            return self
        end;

        getValue = function(self)
            return value
        end;

        getVisualChanged = function(self)
            return visualsChanged
        end;

        setVisualChanged = function(self, change)
            visualsChanged = change or true
            if(change == nil)then visualsChanged = true end
            return self
        end;


        getEventSystem = function(self)
            return eventSystem
        end;


        getParent = function(self)
            return self.parent
        end;

        setPosition = function(self, xPos, yPos, rel)
            if (rel) then
                self.x, self.y = math.floor(self.x + xPos), math.floor(self.y + yPos)
            else
                self.x, self.y = math.floor(xPos), math.floor(yPos)
            end
            visualsChanged = true
            return self
        end;

        getPosition = function(self)
            return self.x, self.y
        end;

        getVisibility = function(self)
            return isVisible
        end;

        setVisibility = function(self, _isVisible)
            isVisible = _isVisible or not isVisible
            visualsChanged = true
            return self
        end;

        setSize = function(self, width, height)
            self.width, self.height = width, height
            eventSystem:sendEvent("basalt_resize", self)
            visualsChanged = true
            return self
        end;

        getHeight = function(self)
            return self.height
        end;

        getWidth = function(self)
            return self.width
        end;

        getSize = function(self)
            return self.width, self.height
        end;

        setBackground = function(self, color)
            self.bgColor = color
            visualsChanged = true
            return self
        end;

        getBackground = function(self)
            return self.bgColor
        end;

        setForeground = function(self, color)
            self.fgColor = color
            visualsChanged = true
            return self
        end;

        getForeground = function(self)
            return self.fgColor
        end;

        showShadow = function(self, show)
            shadow = show or (not shadow)
            return self
        end;

        setShadow = function(self, color)
            shadowColor = color
            return self
        end;

        isShadowActive = function(self)
            return shadow;
        end;

        showBorder = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(v=="left")then
                    borderLeft = true
                end
                if(v=="top")then
                    borderTop = true
                end
                if(v=="right")then
                    borderRight = true
                end
                if(v=="bottom")then
                    borderBottom = true
                end
            end
            return self
        end;

        setBorder = function(self, color)
            shadowColor = color
            return self
        end;
        
        getBorder = function(self, side)
            if(side=="left")then
                return borderLeft;
            end
            if(side=="top")then
                return borderTop;
            end
            if(side=="right")then
                return borderRight;
            end
            if(side=="bottom")then
                return borderBottom;
            end
        end;

        draw = function(self)
            if (isVisible) then
                if(self.parent~=nil)then
                    local x, y = self:getAnchorPosition()
                    if(shadow)then                        
                        self.parent:drawBackgroundBox(x+1, y+self.height, self.width, 1, shadowColor)
                        self.parent:drawBackgroundBox(x+self.width, y+1, 1, self.height, shadowColor)
                        self.parent:drawForegroundBox(x+1, y+self.height, self.width, 1, shadowColor)
                        self.parent:drawForegroundBox(x+self.width, y+1, 1, self.height, shadowColor)
                    end
                    if(borderLeft)then
                        self.parent:drawTextBox(x-1, y, 1, self.height, "\149")
                        self.parent:drawForegroundBox(x-1, y, 1, self.height, borderColor)
                        if(self.bgColor~=false)then self.parent:drawBackgroundBox(x-1, y, 1, self.height, self.bgColor) end
                    end
                    if(borderLeft)and(borderTop)then
                        self.parent:drawTextBox(x-1, y-1, 1, 1, "\151")
                        self.parent:drawForegroundBox(x-1, y-1, 1, 1, borderColor)
                        if(self.bgColor~=false)then self.parent:drawBackgroundBox(x-1, y-1, 1, 1, self.bgColor) end
                    end
                    if(borderTop)then
                        self.parent:drawTextBox(x, y-1, self.width, 1, "\131")
                        self.parent:drawForegroundBox(x, y-1, self.width, 1, borderColor)
                        if(self.bgColor~=false)then self.parent:drawBackgroundBox(x, y-1, self.width, 1, self.bgColor) end
                    end
                    if(borderTop)and(borderRight)then
                        self.parent:drawTextBox(x+self.width, y-1, 1, 1, "\149")
                        self.parent:drawForegroundBox(x+self.width, y-1, 1, 1, borderColor)
                    end
                    if(borderRight)then
                        self.parent:drawTextBox(x+self.width, y, 1, self.height, "\149")
                        self.parent:drawForegroundBox(x+self.width, y, 1, self.height, borderColor)
                    end
                    if(borderRight)and(borderBottom)then
                        self.parent:drawTextBox(x+self.width, y+self.height, 1, 1, "\129")
                        self.parent:drawForegroundBox(x+self.width, y+self.height, 1, 1, borderColor)
                    end
                    if(borderBottom)then
                        self.parent:drawTextBox(x, y+self.height, self.width, 1, "\131")
                        self.parent:drawForegroundBox(x, y+self.height, self.width, 1, borderColor)
                    end
                    if(borderBottom)and(borderLeft)then
                        self.parent:drawTextBox(x-1, y+self.height, 1, 1, "\131")
                        self.parent:drawForegroundBox(x-1, y+self.height, 1, 1, borderColor)
                    end
                end
                return true
            end
            return false
        end;


        getAbsolutePosition = function(self, x, y)
            -- relative position to absolute position
            if (x == nil) or (y == nil) then
                x, y = self:getAnchorPosition()
            end

            if (self.parent ~= nil) then
                local fx, fy = self.parent:getAbsolutePosition(self.parent:getAnchorPosition())
                x = fx + x - 1
                y = fy + y - 1
            end
            return x, y
        end;

        getAnchorPosition = function(self, x, y, ignOff)
            if (x == nil) then
                x = self.x
            end
            if (y == nil) then
                y = self.y
            end
            if (anchor == "top") then
                x = math.floor(self.parent.width/2) + x - 1
            elseif(anchor == "topRight") then
                x = self.parent.width + x - 1
            elseif(anchor == "right") then
                x = self.parent.width + x - 1
                y = math.floor(self.parent.height/2) + y - 1
            elseif(anchor == "bottomRight") then
                x = self.parent.width + x - 1
                y = self.parent.height + y - 1
            elseif(anchor == "bottom") then
                x = math.floor(self.parent.width/2) + x - 1
                y = self.parent.height + y - 1
            elseif(anchor == "bottomLeft") then
                y = self.parent.height + y - 1
            elseif(anchor == "left") then
                y = math.floor(self.parent.height/2) + y - 1
            elseif(anchor == "center") then
                x = math.floor(self.parent.width/2) + x - 1
                y = math.floor(self.parent.height/2) + y - 1
            end
            local xO, yO = self:getOffset()
            if not(ignOffset or ignOff) then
                return x+xO, y+yO
            end
            return x, y
        end;

        getOffset = function(self)
            if (self.parent ~= nil) then
                return self.parent:getFrameOffset()
            end
            return 0, 0
        end;

        ignoreOffset = function(self, ignore)
            ignOffset = ignore
            if(ignore==nil)then ignOffset = true end
            return self
        end;

        getBaseFrame = function(self)
            if(self.parent~=nil)then
                return self.parent:getBaseFrame()
            end
            return self
        end;
        
        setAnchor = function(self, newAnchor)
            anchor = newAnchor
            visualsChanged = true
            return self
        end;

        getAnchor = function(self)
            return anchor
        end;

        onChange = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("value_changed", v)
                end
            end
            return self
        end;

        onClick = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("mouse_click", v)
                    self:registerEvent("monitor_touch", v)
                end
            end
            return self
        end;

        onClickUp = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("mouse_up", v)
                end
            end
            return self
        end;


        onScroll = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("mouse_scroll", v)
                end
            end
            return self
        end;

        onDrag = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("mouse_drag", v)
                end
            end
            return self
        end;

        onEvent = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("custom_event_handler", v)
                end
            end
            return self
        end;

        onKey = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("key", v)
                    self:registerEvent("char", v)
                end
            end
            return self
        end;

        onResize = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("basalt_resize", v)
                end
            end
            return self
        end;

        onKeyUp = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("key_up", v)
                end
            end
            return self
        end;

        onBackgroundKey = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("background_key", v)
                    self:registerEvent("background_char", v)
                end
            end
            return self
        end;

        onBackgroundKeyUp = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("background_key_up", v)
                end
            end
            return self
        end;

        isFocused = function(self)
            if (self.parent ~= nil) then
                return self.parent:getFocusedObject() == self
            end
            return false
        end;

        onGetFocus = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("get_focus", v)
                end
            end
            return self
        end;

        onLoseFocus = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("lose_focus", v)
                end
            end
            return self
        end;

        registerEvent = function(self, event, func)
            return eventSystem:registerEvent(event, func)
        end;

        removeEvent = function(self, event, index)
            return eventSystem:removeEvent(event, index)
        end;

        sendEvent = function(self, event, ...)
            return eventSystem:sendEvent(event, self, ...)
        end;

        mouseHandler = function(self, event, button, x, y)
            local objX, objY = self:getAbsolutePosition(self:getAnchorPosition())
            local yOff = false
            if(objY-1 == y)and(self:getBorder("top"))then
                y = y+1
                yOff = true
            end

            if (objX <= x) and (objX + self.width > x) and (objY <= y) and (objY + self.height > y) and (isVisible) then
                if (self.parent ~= nil) then
                    self.parent:setFocusedObject(self)
                end
                local val = eventSystem:sendEvent(event, self, event, button, x, y)
                if(val~=nil)then return val end
                return true
            end
            return false
        end;

        keyHandler = function(self, event, key)
            if (self:isFocused()) then
                local val = eventSystem:sendEvent(event, self, event, key)
                if(val~=nil)then return val end
                return true
            end
            return false
        end;

        backgroundKeyHandler = function(self, event, key)
            local val = eventSystem:sendEvent("background_"..event, self, event, key)
            if(val~=nil)then return val end
            return true
        end;

        valueChangedHandler = function(self)
            eventSystem:sendEvent("value_changed", self)
        end;

        eventHandler = function(self, event, p1, p2, p3, p4)
            eventSystem:sendEvent("custom_event_handler", self, event, p1, p2, p3, p4)
        end;

        getFocusHandler = function(self)
            local val = eventSystem:sendEvent("get_focus", self)
            if(val~=nil)then return val end
            return true
        end;

        loseFocusHandler = function(self)
            local val = eventSystem:sendEvent("lose_focus", self)
            if(val~=nil)then return val end
            return true
        end;


    }

    object.__index = object
    return object
end
local function Animation(name)
    local object = {}
    local objectType = "Animation"

    local timerObj

    local animations = {}
    local index = 1

    local nextWaitTimer = 0
    local lastFunc

    local function onPlay()
        if (animations[index] ~= nil) then
            animations[index].f(object, index)
        end
        index = index + 1
        if (animations[index] ~= nil) then
            if (animations[index].t > 0) then
                timerObj = os.startTimer(animations[index].t)
            else
                onPlay()
            end
        end
    end

    object = {
        name = name,
        getType = function(self)
            return objectType
        end;

        getZIndex = function(self)
            return 1
        end;

        getName = function(self)
            return self.name
        end;

        add = function(self, func, wait)
            lastFunc = func
            table.insert(animations, { f = func, t = wait or nextWaitTimer })
            return self
        end;

        wait = function(self, wait)
            nextWaitTimer = wait
            return self
        end;

        rep = function(self, reps)
            for x = 1, reps do
                table.insert(animations, { f = lastFunc, t = nextWaitTimer })
            end
            return self
        end;

        clear = function(self)
            animations = {}
            lastFunc = nil
            nextWaitTimer = 0
            index = 1
            return self
        end;

        play = function(self)
            index = 1
            if (animations[index] ~= nil) then
                if (animations[index].t > 0) then
                    timerObj = os.startTimer(animations[index].t)
                else
                    onPlay()
                end
            end
            return self
        end;

        cancel = function(self)
            os.cancelTimer(timerObj)
            return self
        end;

        eventHandler = function(self, event, tObj)
            if (event == "timer") and (tObj == timerObj) then
                if (animations[index] ~= nil) then
                    onPlay()
                end
            end
        end;
    }
    object.__index = object

    return object
end
local function Button(name)
    -- Button
    local base = Object(name)
    local objectType = "Button"

    base:setValue("Button")
    base:setZIndex(5)
    base.width = 8
    base.bgColor = theme.ButtonBG
    base.fgColor = theme.ButtonFG

    local textHorizontalAlign = "center"
    local textVerticalAlign = "center"

    local object = {
        getType = function(self)
            return objectType
        end;
        setHorizontalAlign = function(self, pos)
            textHorizontalAlign = pos
        end;

        setVerticalAlign = function(self, pos)
            textVerticalAlign = pos
        end;

        setText = function(self, text)
            base:setValue(text)
            return self
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    local verticalAlign = getTextVerticalAlign(self.height, textVerticalAlign)

                    if(self.bgColor~=false)then
                        self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                        self.parent:drawTextBox(obx, oby, self.width, self.height, " ")
                    end
                    if(self.fgColor~=false)then self.parent:drawForegroundBox(obx, oby, self.width, self.height, self.fgColor) end
                    for n = 1, self.height do
                        if (n == verticalAlign) then
                            self.parent:setText(obx, oby + (n - 1), getTextHorizontalAlign(self:getValue(), self.width, textHorizontalAlign))
                        end
                    end
                end
                self:setVisualChanged(false)
            end
        end;

    }
    return setmetatable(object, base)
end
local function Checkbox(name)
    -- Checkbox
    local base = Object(name)
    local objectType = "Checkbox"

    base:setZIndex(5)
    base:setValue(false)
    base.width = 1
    base.height = 1
    base.bgColor = theme.CheckboxBG
    base.fgColor = theme.CheckboxFG

    local object = {
        symbol = "\42",

        getType = function(self)
            return objectType
        end;

        mouseHandler = function(self, event, button, x, y)
            if (base.mouseHandler(self, event, button, x, y)) then
                if ((event == "mouse_click") and (button == 1)) or (event == "monitor_touch") then
                    if (self:getValue() ~= true) and (self:getValue() ~= false) then
                        self:setValue(false)
                    else
                        self:setValue(not self:getValue())
                    end
                end
                return true
            end
            return false
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    local verticalAlign = getTextVerticalAlign(self.height, "center")

                    if(self.bgColor~=false)then self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor) end
                    for n = 1, self.height do
                        if (n == verticalAlign) then
                            if (self:getValue() == true) then
                                self.parent:writeText(obx, oby + (n - 1), getTextHorizontalAlign(self.symbol, self.width, "center"), self.bgColor, self.fgColor)
                            else
                                self.parent:writeText(obx, oby + (n - 1), getTextHorizontalAlign(" ", self.width, "center"), self.bgColor, self.fgColor)
                            end
                        end
                    end
                end
                self:setVisualChanged(false)
            end
        end;

    }

    return setmetatable(object, base)
end
local function Dropdown(name)
    local base = Object(name)
    local objectType = "Dropdown"
    base.width = 12
    base.height = 1
    base.bgColor = theme.dropdownBG
    base.fgColor = theme.dropdownFG
    base:setZIndex(6)

    local list = {}
    local itemSelectedBG = theme.selectionBG
    local itemSelectedFG = theme.selectionFG
    local selectionColorActive = true
    local align = "left"
    local yOffset = 0

    local dropdownW = 16
    local dropdownH = 6
    local closedSymbol = "\16"
    local openedSymbol = "\31"
    local isOpened = false

    local object = {
        getType = function(self)
            return objectType
        end;

        setIndexOffset = function(self, yOff)
            yOffset = yOff
            return self
        end;

        getIndexOffset = function(self)
            return yOffset
        end;

        addItem = function(self, text, bgCol, fgCol, ...)
            table.insert(list, { text = text, bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            return self
        end;

        getAll = function(self)
            return list
        end;

        removeItem = function(self, index)
            table.remove(list, index)
            return self
        end;

        getItem = function(self, index)
            return list[index]
        end;

        getItemIndex = function(self)
            local selected = self:getValue()
            for key, value in pairs(list) do
                if (value == selected) then
                    return key
                end
            end
        end;

        clear = function(self)
            list = {}
            self:setValue({})
            return self
        end;

        getItemCount = function(self)
            return #list
        end;

        editItem = function(self, index, text, bgCol, fgCol, ...)
            table.remove(list, index)
            table.insert(list, index, { text = text, bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            return self
        end;

        selectItem = function(self, index)
            self:setValue(list[index] or {})
            return self
        end;

        setSelectedItem = function(self, bgCol, fgCol, active)
            itemSelectedBG = bgCol or self.bgColor
            itemSelectedFG = fgCol or self.fgColor
            selectionColorActive = active
            return self
        end;

        setDropdownSize = function(self, width, height)
            dropdownW, dropdownH = width, height
            return self
        end;

        mouseHandler = function(self, event, button, x, y)
            if (isOpened) then
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                if ((event == "mouse_click") and (button == 1)) or (event == "monitor_touch") then

                    if (#list > 0) then
                        for n = 1, dropdownH do
                            if (list[n + yOffset] ~= nil) then
                                if (obx <= x) and (obx + dropdownW > x) and (oby + n == y) then
                                    self:setValue(list[n + yOffset])
                                    return true
                                end
                            end
                        end
                    end
                end

                if (event == "mouse_scroll") then
                    yOffset = yOffset + button
                    if (yOffset < 0) then
                        yOffset = 0
                    end
                    if (button == 1) then
                        if (#list > dropdownH) then
                            if (yOffset > #list - dropdownH) then
                                yOffset = #list - dropdownH
                            end
                        else
                            yOffset = list - 1
                        end
                    end
                    return true
                end
                self:setVisualChanged()
            end
            if (base.mouseHandler(self, event, button, x, y)) then
                isOpened = true
            else
                isOpened = false
            end
        end;

        draw = function(self)
            if (base.draw(self)) then
                local obx, oby = self:getAnchorPosition()
                if (self.parent ~= nil) then
                    if(self.bgColor~=false)then self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor) end
                    local val = self:getValue()
                    local text = getTextHorizontalAlign((val~=nil and val.text or ""), self.width, align):sub(1, self.width - 1)  .. (isOpened and openedSymbol or closedSymbol)
                    self.parent:writeText(obx, oby, text, self.bgColor, self.fgColor)

                    if (isOpened) then
                        for n = 1, dropdownH do
                            if (list[n + yOffset] ~= nil) then
                                if (list[n + yOffset] == val) then
                                    if (selectionColorActive) then
                                        self.parent:writeText(obx, oby + n, getTextHorizontalAlign(list[n + yOffset].text, dropdownW, align), itemSelectedBG, itemSelectedFG)
                                    else
                                        self.parent:writeText(obx, oby + n, getTextHorizontalAlign(list[n + yOffset].text, dropdownW, align), list[n + yOffset].bgCol, list[n + yOffset].fgCol)
                                    end
                                else
                                    self.parent:writeText(obx, oby + n, getTextHorizontalAlign(list[n + yOffset].text, dropdownW, align), list[n + yOffset].bgCol, list[n + yOffset].fgCol)
                                end
                            end
                        end
                    end
                end
                self:setVisualChanged(false)
            end
        end;
    }

    return setmetatable(object, base)
end
local function Image(name)
    -- Pane
    local base = Object(name)
    local objectType = "Image"
    base:setZIndex(2)
    local image
    local shrinkedImage
    local imageGotShrinked = false

    local function shrink()

        -- shrinkSystem is copy pasted (and slightly changed) from blittle by Bomb Bloke: http://www.computercraft.info/forums2/index.php?/topic/25354-cc-176-blittle-api/
        local relations = { [0] = { 8, 4, 3, 6, 5 }, { 4, 14, 8, 7 }, { 6, 10, 8, 7 }, { 9, 11, 8, 0 }, { 1, 14, 8, 0 }, { 13, 12, 8, 0 }, { 2, 10, 8, 0 }, { 15, 8, 10, 11, 12, 14 },
                            { 0, 7, 1, 9, 2, 13 }, { 3, 11, 8, 7 }, { 2, 6, 7, 15 }, { 9, 3, 7, 15 }, { 13, 5, 7, 15 }, { 5, 12, 8, 7 }, { 1, 4, 7, 15 }, { 7, 10, 11, 12, 14 } }

        local colourNum, exponents, colourChar = {}, {}, {}
        for i = 0, 15 do
            exponents[2 ^ i] = i
        end
        do
            local hex = "0123456789abcdef"
            for i = 1, 16 do
                colourNum[hex:sub(i, i)] = i - 1
                colourNum[i - 1] = hex:sub(i, i)
                colourChar[hex:sub(i, i)] = 2 ^ (i - 1)
                colourChar[2 ^ (i - 1)] = hex:sub(i, i)

                local thisRel = relations[i - 1]
                for i = 1, #thisRel do
                    thisRel[i] = 2 ^ thisRel[i]
                end
            end
        end

        local function getBestColourMatch(usage)
            local lastCol = relations[exponents[usage[#usage][1]]]

            for j = 1, #lastCol do
                local thisRelation = lastCol[j]
                for i = 1, #usage - 1 do
                    if usage[i][1] == thisRelation then
                        return i
                    end
                end
            end

            return 1
        end

        local function colsToChar(pattern, totals)
            if not totals then
                local newPattern = {}
                totals = {}
                for i = 1, 6 do
                    local thisVal = pattern[i]
                    local thisTot = totals[thisVal]
                    totals[thisVal], newPattern[i] = thisTot and (thisTot + 1) or 1, thisVal
                end
                pattern = newPattern
            end

            local usage = {}
            for key, value in pairs(totals) do
                usage[#usage + 1] = { key, value }
            end

            if #usage > 1 then
                -- Reduce the chunk to two colours:
                while #usage > 2 do
                    table.sort(usage, function(a, b)
                        return a[2] > b[2]
                    end)
                    local matchToInd, usageLen = getBestColourMatch(usage), #usage
                    local matchFrom, matchTo = usage[usageLen][1], usage[matchToInd][1]
                    for i = 1, 6 do
                        if pattern[i] == matchFrom then
                            pattern[i] = matchTo
                            usage[matchToInd][2] = usage[matchToInd][2] + 1
                        end
                    end
                    usage[usageLen] = nil
                end

                -- Convert to character. Adapted from oli414's function:
                -- http://www.computercraft.info/forums2/index.php?/topic/25340-cc-176-easy-drawing-characters/
                local data = 128
                for i = 1, #pattern - 1 do
                    if pattern[i] ~= pattern[6] then
                        data = data + 2 ^ (i - 1)
                    end
                end
                return string.char(data), colourChar[usage[1][1] == pattern[6] and usage[2][1] or usage[1][1]], colourChar[pattern[6]]
            else
                -- Solid colour character:
                return "\128", colourChar[pattern[1]], colourChar[pattern[1]]
            end
        end

        local results, width, height, bgCol = { {}, {}, {} }, 0, #image + #image % 3, base.bgColor or colors.black
        for i = 1, #image do
            if #image[i] > width then
                width = #image[i]
            end
        end

        for y = 0, height - 1, 3 do
            local cRow, tRow, bRow, counter = {}, {}, {}, 1

            for x = 0, width - 1, 2 do
                -- Grab a 2x3 chunk:
                local pattern, totals = {}, {}

                for yy = 1, 3 do
                    for xx = 1, 2 do
                        pattern[#pattern + 1] = (image[y + yy] and image[y + yy][x + xx]) and (image[y + yy][x + xx] == 0 and bgCol or image[y + yy][x + xx]) or bgCol
                        totals[pattern[#pattern]] = totals[pattern[#pattern]] and (totals[pattern[#pattern]] + 1) or 1
                    end
                end

                cRow[counter], tRow[counter], bRow[counter] = colsToChar(pattern, totals)
                counter = counter + 1
            end

            results[1][#results[1] + 1], results[2][#results[2] + 1], results[3][#results[3] + 1] = table.concat(cRow), table.concat(tRow), table.concat(bRow)
        end

        results.width, results.height = #results[1][1], #results[1]

        shrinkedImage = results
    end

    local object = {
        getType = function(self)
            return objectType
        end;

        loadImage = function(self, path)
            image = paintutils.loadImage(path)
            imageGotShrinked = false
            return self
        end;

        loadBlittleImage = function(self, path) -- not done yet
            --image = paintutils.loadImage(path)
            --imageGotShrinked = true
            return self
        end;

        shrink = function(self)
            shrink()
            imageGotShrinked = true
            return self
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    if (image ~= nil) then
                        local obx, oby = self:getAnchorPosition()
                        if (imageGotShrinked) then
                            -- this is copy pasted (and slightly changed) from blittle by Bomb Bloke: http://www.computercraft.info/forums2/index.php?/topic/25354-cc-176-blittle-api/
                            local t, tC, bC = shrinkedImage[1], shrinkedImage[2], shrinkedImage[3]
                            for i = 1, shrinkedImage.height do
                                local tI = t[i]
                                if type(tI) == "string" then
                                    self.parent:setText(obx, oby + i - 1, tI)
                                    self.parent:setFG(obx, oby + i - 1, tC[i])
                                    self.parent:setBG(obx, oby + i - 1, bC[i])
                                elseif type(tI) == "table" then
                                    self.parent:setText(obx, oby + i - 1, tI[2])
                                    self.parent:setFG(obx, oby + i - 1, tC[i])
                                    self.parent:setBG(obx, oby + i - 1, bC[i])
                                end
                            end
                        else
                            for yPos = 1, math.min(#image, self.height) do
                                local line = image[yPos]
                                for xPos = 1, math.min(#line, self.width) do
                                    if line[xPos] > 0 then
                                        self.parent:drawBackgroundBox(obx + xPos - 1, oby + yPos - 1, 1, 1, line[xPos])
                                    end
                                end
                            end
                        end
                    end
                end
                self:setVisualChanged(false)
            end
        end;
    }

    return setmetatable(object, base)
end
local function Input(name)
    -- Input
    local base = Object(name)
    local objectType = "Input"

    local inputType = "text"
    local inputLimit = 0
    base:setZIndex(5)
    base:setValue("")
    base.width = 10
    base.height = 1
    base.bgColor = theme.InputBG
    base.fgColor = theme.InputFG

    local textX = 1
    local wIndex = 1

    local defaultText = ""
    local defaultBGCol
    local defaultFGCol
    local showingText = defaultText
    local internalValueChange = false

    local object = {

        getType = function(self)
            return objectType
        end;

        setInputType = function(self, iType)
            if (iType == "password") or (iType == "number") or (iType == "text") then
                inputType = iType
            end
            return self
        end;

        setDefaultText = function(self, text, fCol, bCol)
            defaultText = text
            defaultBGCol = bCol or defaultBGCol
            defaultFGCol = fCol or defaultFGCol
            if (self:isFocused()) then
                showingText = ""
            else
                showingText = defaultText
            end
            return self
        end;

        getInputType = function(self)
            return inputType
        end;

        setValue = function(self, val)
            base.setValue(self, tostring(val))
            if not (internalValueChange) then
                textX = tostring(val):len() + 1
            end
            return self
        end;

        getValue = function(self)
            local val = base.getValue(self)
            return inputType == "number" and tonumber(val) or val
        end;

        setInputLimit = function(self, limit)
            inputLimit = tonumber(limit) or inputLimit
            return self
        end;

        getInputLimit = function(self)
            return inputLimit
        end;

        getFocusHandler = function(self)
            base.getFocusHandler(self)
            if (self.parent ~= nil) then
                local obx, oby = self:getAnchorPosition()
                showingText = ""
                if (self.parent ~= nil) then
                    self.parent:setCursor(true, obx + textX - wIndex, oby+math.floor(self.height/2), self.fgColor)
                end
            end
        end;

        loseFocusHandler = function(self)
            base.loseFocusHandler(self)
            if (self.parent ~= nil) then
                self.parent:setCursor(false)
                showingText = defaultText
            end
        end;

        keyHandler = function(self, event, key)
            if (base.keyHandler(self, event, key)) then
                internalValueChange = true
                if (event == "key") then
                    if (key == keys.backspace) then
                        -- on backspace
                        local text = tostring(base.getValue())
                        if (textX > 1) then
                            self:setValue(text:sub(1, textX - 2) .. text:sub(textX, text:len()))
                            if (textX > 1) then
                                textX = textX - 1
                            end
                            if (wIndex > 1) then
                                if (textX < wIndex) then
                                    wIndex = wIndex - 1
                                end
                            end
                        end
                    end
                    if (key == keys.enter) then
                        -- on enter
                        if (self.parent ~= nil) then
                            --self.parent:removeFocusedObject(self)
                        end
                    end
                    if (key == keys.right) then
                        -- right arrow
                        local tLength = tostring(base.getValue()):len()
                        textX = textX + 1

                        if (textX > tLength) then
                            textX = tLength + 1
                        end
                        if (textX < 1) then
                            textX = 1
                        end
                        if (textX < wIndex) or (textX >= self.width + wIndex) then
                            wIndex = textX - self.width + 1
                        end
                        if (wIndex < 1) then
                            wIndex = 1
                        end
                    end

                    if (key == keys.left) then
                        -- left arrow
                        textX = textX - 1
                        if (textX >= 1) then
                            if (textX < wIndex) or (textX >= self.width + wIndex) then
                                wIndex = textX
                            end
                        end
                        if (textX < 1) then
                            textX = 1
                        end
                        if (wIndex < 1) then
                            wIndex = 1
                        end
                    end
                end

                if (event == "char") then
                    local text = base.getValue()
                    if (text:len() < inputLimit or inputLimit <= 0) then
                        if (inputType == "number") then
                            local cache = text
                            if (key == ".") or (tonumber(key) ~= nil) then
                                self:setValue(text:sub(1, textX - 1) .. key .. text:sub(textX, text:len()))
                                textX = textX + 1
                            end
                            if (tonumber(base.getValue()) == nil) then
                                self:setValue(cache)
                            end
                        else
                            self:setValue(text:sub(1, textX - 1) .. key .. text:sub(textX, text:len()))
                            textX = textX + 1
                        end
                        if (textX >= self.width + wIndex) then
                            wIndex = wIndex + 1
                        end
                    end
                end
                local obx, oby = self:getAnchorPosition()
                local val = tostring(base.getValue())
                local cursorX = (textX <= val:len() and textX - 1 or val:len()) - (wIndex - 1)

                if (cursorX > self.x + self.width - 1) then
                    cursorX = self.x + self.width - 1
                end
                if (self.parent ~= nil) then
                    self.parent:setCursor(true, obx + cursorX, oby+math.floor(self.height/2), self.fgColor)
                end
                internalValueChange = false
            end
        end;

        mouseHandler = function(self, event, button, x, y)
            if (base.mouseHandler(self, event, button, x, y)) then
                if (event == "mouse_click") and (button == 1) then

                end
                return true
            end
            return false
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    local verticalAlign = getTextVerticalAlign(self.height, "center")

                    if(self.bgColor~=false)then self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor) end
                    for n = 1, self.height do
                        if (n == verticalAlign) then
                            local val = tostring(base.getValue())
                            local bCol = self.bgColor
                            local fCol = self.fgColor
                            local text
                            if (val:len() <= 0) then
                                text = showingText
                                bCol = defaultBGCol or bCol
                                fCol = defaultFGCol or fCol
                            end

                            text = showingText
                            if (val ~= "") then
                                text = val
                            end
                            text = text:sub(wIndex, self.width + wIndex - 1)
                            local space = self.width - text:len()
                            if (space < 0) then
                                space = 0
                            end
                            if (inputType == "password") and (val ~= "") then
                                text = string.rep("*", text:len())
                            end
                            text = text .. string.rep(" ", space)
                            self.parent:writeText(obx, oby + (n - 1), text, bCol, fCol)
                        end
                    end
                end
                self:setVisualChanged(false)
            end
        end;
    }

    return setmetatable(object, base)
end
local function Label(name)
    -- Label
    local base = Object(name)
    local objectType = "Label"

    base:setZIndex(3)
    base.fgColor = colors.white
    base.bgcolor = colors.black

    local autoSize = true
    base:setValue("")

    local textHorizontalAlign = "left"
    local textVerticalAlign = "top"
    local fontsize = 0

    local object = {
        getType = function(self)
            return objectType
        end;
        setText = function(self, text)
            text = tostring(text)
            base:setValue(text)
            if (autoSize) then
                self.width = text:len()
            end
            return self
        end;

        setTextAlign = function(self, hor, vert)
            textHorizontalAlign = hor or textHorizontalAlign
            textVerticalAlign = vert or textVerticalAlign
            self:setVisualChanged()
            return self
        end;

        setFontSize = function(self, size)
            if(size>0)and(size<=4)then
                fontsize = size-1 or 0
            end
            return self
        end;

        getFontSize = function(self)
            return fontsize+1
        end;

        setSize = function(self, width, height)
            base.setSize(self, width, height)
            autoSize = false
            self:setVisualChanged()
            return self
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    local verticalAlign = getTextVerticalAlign(self.height, textVerticalAlign)
                    if(self.bgColor~=false)then 
                        self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                        self.parent:drawTextBox(obx, oby, self.width, self.height, " ") end
                    if(self.fgColor~=false)then self.parent:drawForegroundBox(obx, oby, self.width, self.height, self.fgColor) end
                    if(fontsize==0)then
                        for n = 1, self.height do
                            if (n == verticalAlign) then
                                self.parent:setText(obx, oby + (n - 1), getTextHorizontalAlign(self:getValue(), self.width, textHorizontalAlign))
                            end
                        end
                    else
                        local tData = makeText(fontsize, self:getValue(), self.fgColor, self.bgColor or colors.black)
                        if(autoSize)then
                            self.height = #tData[1]-1
                            self.width = #tData[1][1]
                        end
                        for n = 1, self.height do
                            if (n == verticalAlign) then
                                local oX, oY = self.parent:getSize()
                                local cX, cY = #tData[1][1], #tData[1]
                                obx = obx or math.floor((oX - cX) / 2) + 1
                                oby = oby or math.floor((oY - cY) / 2) + 1
                            
                                for i = 1, cY do
                                    self.parent:setFG(obx, oby + i + n - 2, getTextHorizontalAlign(tData[2][i], self.width, textHorizontalAlign))
                                    self.parent:setBG(obx, oby + i + n - 2, getTextHorizontalAlign(tData[3][i], self.width, textHorizontalAlign, tHex[self.bgColor or colors.black]))
                                    self.parent:setText(obx, oby + i + n - 2, getTextHorizontalAlign(tData[1][i], self.width, textHorizontalAlign))
                                end
                            end
                        end
                    end
                end
                self:setVisualChanged(false)
            end
        end;

    }

    return setmetatable(object, base)
end
local function List(name)
    local base = Object(name)
    local objectType = "List"
    base.width = 16
    base.height = 6
    base.bgColor = theme.listBG
    base.fgColor = theme.listFG
    base:setZIndex(5)

    local list = {}
    local itemSelectedBG = theme.selectionBG
    local itemSelectedFG = theme.selectionFG
    local selectionColorActive = true
    local align = "left"
    local yOffset = 0
    local scrollable = true

    local object = {
        getType = function(self)
            return objectType
        end;

        addItem = function(self, text, bgCol, fgCol, ...)
            table.insert(list, { text = text, bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            if (#list == 1) then
                self:setValue(list[1])
            end
            return self
        end;

        setIndexOffset = function(self, yOff)
            yOffset = yOff
            return self
        end;

        getIndexOffset = function(self)
            return yOffset
        end;

        removeItem = function(self, index)
            table.remove(list, index)
            return self
        end;

        getItem = function(self, index)
            return list[index]
        end;

        getAll = function(self)
            return list
        end;

        getItemIndex = function(self)
            local selected = self:getValue()
            for key, value in pairs(list) do
                if (value == selected) then
                    return key
                end
            end
        end;

        clear = function(self)
            list = {}
            self:setValue({})
            return self
        end;

        getItemCount = function(self)
            return #list
        end;

        editItem = function(self, index, text, bgCol, fgCol, ...)
            table.remove(list, index)
            table.insert(list, index, { text = text, bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            return self
        end;

        selectItem = function(self, index)
            self:setValue(list[index] or {})
            return self
        end;

        setSelectedItem = function(self, bgCol, fgCol, active)
            itemSelectedBG = bgCol or self.bgColor
            itemSelectedFG = fgCol or self.fgColor
            selectionColorActive = active
            return self
        end;

        setScrollable = function(self, scroll)
            scrollable = scroll
            return self
        end;

        mouseHandler = function(self, event, button, x, y)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            if (obx <= x) and (obx + self.width > x) and (oby <= y) and (oby + self.height > y) and (self:isVisible()) then
                if (((event == "mouse_click") or (event == "mouse_drag"))and(button==1))or(event=="monitor_touch") then
                    if (#list > 0) then
                        for n = 1, self.height do
                            if (list[n + yOffset] ~= nil) then
                                if (obx <= x) and (obx + self.width > x) and (oby + n - 1 == y) then
                                    self:setValue(list[n + yOffset])
                                    self:getEventSystem():sendEvent("mouse_click", self, "mouse_click", 0, x, y, list[n + yOffset])
                                end
                            end
                        end
                    end
                end

                if (event == "mouse_scroll") and (scrollable) then
                    yOffset = yOffset + button
                    if (yOffset < 0) then
                        yOffset = 0
                    end
                    if (button >= 1) then
                        if (#list > self.height) then
                            if (yOffset > #list - self.height) then
                                yOffset = #list - self.height
                            end
                            if (yOffset >= #list) then
                                yOffset = #list - 1
                            end
                        else
                            yOffset = yOffset - 1
                        end
                    end
                end
                self:setVisualChanged()
                return true
            end
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    if(self.bgColor~=false)then
                        self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                    end
                    for n = 1, self.height do
                        if (list[n + yOffset] ~= nil) then
                            if (list[n + yOffset] == self:getValue()) then
                                if (selectionColorActive) then
                                    self.parent:writeText(obx, oby + n - 1, getTextHorizontalAlign(list[n + yOffset].text, self.width, align), itemSelectedBG, itemSelectedFG)
                                else
                                    self.parent:writeText(obx, oby + n - 1, getTextHorizontalAlign(list[n + yOffset].text, self.width, align), list[n + yOffset].bgCol, list[n + yOffset].fgCol)
                                end
                            else
                                self.parent:writeText(obx, oby + n - 1, getTextHorizontalAlign(list[n + yOffset].text, self.width, align), list[n + yOffset].bgCol, list[n + yOffset].fgCol)
                            end
                        end
                    end
                end
                self:setVisualChanged(false)
            end
        end;
    }

    return setmetatable(object, base)
end
local function Menubar(name)
    local base = Object(name)
    local objectType = "Menubar"
    local object = {}

    base.width = 30
    base.height = 1
    base.bgColor = colors.gray
    base.fgColor = colors.lightGray
    base:setZIndex(5)

    local list = {}
    local itemSelectedBG = theme.selectionBG
    local itemSelectedFG = theme.selectionFG
    local selectionColorActive = true
    local align = "left"
    local itemOffset = 0
    local space = 1
    local scrollable = false

    local function maxScroll()
        local mScroll = 0
        local xPos = 0
        for n = 1, #list do
            if (xPos + list[n].text:len() + space * 2 > object.width) then
                if(xPos < object.width)then
                    mScroll = mScroll + (list[n].text:len() + space * 2-(object.width - xPos))
                else
                    mScroll = mScroll + list[n].text:len() + space * 2
                end
            end
            xPos = xPos + list[n].text:len() + space * 2

        end
        return mScroll
    end

    object = {
        getType = function(self)
            return objectType
        end;

        addItem = function(self, text, bgCol, fgCol, ...)
            table.insert(list, { text = text, bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            if (#list == 1) then
                self:setValue(list[1])
            end
            return self
        end;

        getAll = function(self)
            return list
        end;

        getItemIndex = function(self)
            local selected = self:getValue()
            for key, value in pairs(list) do
                if (value == selected) then
                    return key
                end
            end
        end;

        clear = function(self)
            list = {}
            self:setValue({})
            return self
        end;

        setSpace = function(self, _space)
            space = _space or space
            return self
        end;

        setPositionOffset = function(self, offset)
            itemOffset = offset or 0
            if (itemOffset < 0) then
                itemOffset = 0
            end

            local mScroll = maxScroll()
            if (itemOffset > mScroll) then
                itemOffset = mScroll
            end
            return self
        end;

        getPositionOffset = function(self)
            return itemOffset
        end;

        setScrollable = function(self, scroll)
            scrollable = scroll
            if(scroll==nil)then scrollable = true end
            return self
        end;

        removeItem = function(self, index)
            table.remove(list, index)
            return self
        end;

        getItem = function(self, index)
            return list[index]
        end;

        getItemCount = function(self)
            return #list
        end;

        editItem = function(self, index, text, bgCol, fgCol, ...)
            table.remove(list, index)
            table.insert(list, index, { text = text, bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            return self
        end;

        selectItem = function(self, index)
            self:setValue(list[index] or {})
            return self
        end;

        setSelectedItem = function(self, bgCol, fgCol, active)
            itemSelectedBG = bgCol or self.bgColor
            itemSelectedFG = fgCol or self.fgColor
            selectionColorActive = active
            return self
        end;

        mouseHandler = function(self, event, button, x, y)
            if(base.mouseHandler(self, event, button, x, y))then
                local objX, objY = self:getAbsolutePosition(self:getAnchorPosition())
                if (objX <= x) and (objX + self.width > x) and (objY <= y) and (objY + self.height > y) and (self:isVisible()) then
                    if (self.parent ~= nil) then
                        self.parent:setFocusedObject(self)
                    end
                    if (event == "mouse_click") or (event == "monitor_touch") then
                        local xPos = 0
                        for n = 1, #list do
                            if (list[n] ~= nil) then
                                --if (xPos-1 + list[n].text:len() + space * 2 <= self.width) then
                                if (objX + xPos <= x + itemOffset) and (objX + xPos + list[n].text:len() + (space*2) > x + itemOffset) and (objY == y) then
                                    self:setValue(list[n])
                                    self:getEventSystem():sendEvent(event, self, event, 0, x, y, list[n])
                                end
                                xPos = xPos + list[n].text:len() + space * 2
                            end
                        end

                    end
                    if (event == "mouse_scroll") and (scrollable) then
                        itemOffset = itemOffset + button
                        if (itemOffset < 0) then
                            itemOffset = 0
                        end

                        local mScroll = maxScroll()

                        if (itemOffset > mScroll) then
                            itemOffset = mScroll
                        end
                    end
                    self:setVisualChanged(true)
                    return true
                end
            end
            return false
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    if(self.bgColor~=false)then
                        self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                    end
                    local text = ""
                    local textBGCol = ""
                    local textFGCol = ""
                    for _, v in pairs(list) do
                        local newItem = (" "):rep(space) .. v.text .. (" "):rep(space)
                        text = text .. newItem
                        if(v == self:getValue())then
                            textBGCol = textBGCol .. tHex[itemSelectedBG or v.bgCol or self.bgColor]:rep(newItem:len())
                            textFGCol = textFGCol .. tHex[itemSelectedFG or v.FgCol or self.fgColor]:rep(newItem:len())
                        else
                            textBGCol = textBGCol .. tHex[v.bgCol or self.bgColor]:rep(newItem:len())
                            textFGCol = textFGCol .. tHex[v.FgCol or self.fgColor]:rep(newItem:len())
                        end
                    end

                    self.parent:setText(obx, oby, text:sub(itemOffset+1, self.width+itemOffset))
                    self.parent:setBG(obx, oby, textBGCol:sub(itemOffset+1, self.width+itemOffset))
                    self.parent:setFG(obx, oby, textFGCol:sub(itemOffset+1, self.width+itemOffset))
                end
                self:setVisualChanged(false)
            end
        end;
    }

    return setmetatable(object, base)
end
local function Pane(name)
    -- Pane
    local base = Object(name)
    local objectType = "Pane"

    local object = {
        getType = function(self)
            return objectType
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                    self.parent:drawForegroundBox(obx, oby, self.width, self.height, self.bgColor)
                end
                self:setVisualChanged(false)
            end
        end;

    }

    return setmetatable(object, base)
end
local function Program(name)
    local base = Object(name)
    local objectType = "Program"
    base:setZIndex(5)
    local object

    local function createBasaltWindow(x, y, width, height)
        local xCursor, yCursor = 1, 1
        local bgColor, fgColor = colors.black, colors.white
        local cursorBlink = false
        local visible = false

        local cacheT = {}
        local cacheBG = {}
        local cacheFG = {}

        local tPalette = {}

        local emptySpaceLine
        local emptyColorLines = {}

        for i = 0, 15 do
            local c = 2 ^ i
            tPalette[c] = { parentTerminal.getPaletteColour(c) }
        end

        local function createEmptyLines()
            emptySpaceLine = (" "):rep(width)
            for n = 0, 15 do
                local nColor = 2 ^ n
                local sHex = tHex[nColor]
                emptyColorLines[nColor] = sHex:rep(width)
            end
        end

        local function recreateWindowArray()
            createEmptyLines()
            local emptyText = emptySpaceLine
            local emptyFG = emptyColorLines[colors.white]
            local emptyBG = emptyColorLines[colors.black]
            for n = 1, height do
                cacheT[n] = sub(cacheT[n] == nil and emptyText or cacheT[n] .. emptyText:sub(1, width - cacheT[n]:len()), 1, width)
                cacheFG[n] = sub(cacheFG[n] == nil and emptyFG or cacheFG[n] .. emptyFG:sub(1, width - cacheFG[n]:len()), 1, width)
                cacheBG[n] = sub(cacheBG[n] == nil and emptyBG or cacheBG[n] .. emptyBG:sub(1, width - cacheBG[n]:len()), 1, width)
            end
        end
        recreateWindowArray()

        local function updateCursor()
            if xCursor >= 1 and yCursor >= 1 and xCursor <= width and yCursor <= height then
                --parentTerminal.setCursorPos(xCursor + x - 1, yCursor + y - 1)
            else
                --parentTerminal.setCursorPos(0, 0)
            end
            --parentTerminal.setTextColor(fgColor)
        end

        local function internalBlit(sText, sTextColor, sBackgroundColor)
            -- copy pasti strikes again (cc: window.lua)
            local nStart = xCursor
            local nEnd = nStart + #sText - 1
            if yCursor >= 1 and yCursor <= height then
                if nStart <= width and nEnd >= 1 then
                    -- Modify line
                    if nStart == 1 and nEnd == width then
                        cacheT[yCursor] = sText
                        cacheFG[yCursor] = sTextColor
                        cacheBG[yCursor] = sBackgroundColor
                    else
                        local sClippedText, sClippedTextColor, sClippedBackgroundColor
                        if nStart < 1 then
                            local nClipStart = 1 - nStart + 1
                            local nClipEnd = width - nStart + 1
                            sClippedText = sub(sText, nClipStart, nClipEnd)
                            sClippedTextColor = sub(sTextColor, nClipStart, nClipEnd)
                            sClippedBackgroundColor = sub(sBackgroundColor, nClipStart, nClipEnd)
                        elseif nEnd > width then
                            local nClipEnd = width - nStart + 1
                            sClippedText = sub(sText, 1, nClipEnd)
                            sClippedTextColor = sub(sTextColor, 1, nClipEnd)
                            sClippedBackgroundColor = sub(sBackgroundColor, 1, nClipEnd)
                        else
                            sClippedText = sText
                            sClippedTextColor = sTextColor
                            sClippedBackgroundColor = sBackgroundColor
                        end

                        local sOldText = cacheT[yCursor]
                        local sOldTextColor = cacheFG[yCursor]
                        local sOldBackgroundColor = cacheBG[yCursor]
                        local sNewText, sNewTextColor, sNewBackgroundColor
                        if nStart > 1 then
                            local nOldEnd = nStart - 1
                            sNewText = sub(sOldText, 1, nOldEnd) .. sClippedText
                            sNewTextColor = sub(sOldTextColor, 1, nOldEnd) .. sClippedTextColor
                            sNewBackgroundColor = sub(sOldBackgroundColor, 1, nOldEnd) .. sClippedBackgroundColor
                        else
                            sNewText = sClippedText
                            sNewTextColor = sClippedTextColor
                            sNewBackgroundColor = sClippedBackgroundColor
                        end
                        if nEnd < width then
                            local nOldStart = nEnd + 1
                            sNewText = sNewText .. sub(sOldText, nOldStart, width)
                            sNewTextColor = sNewTextColor .. sub(sOldTextColor, nOldStart, width)
                            sNewBackgroundColor = sNewBackgroundColor .. sub(sOldBackgroundColor, nOldStart, width)
                        end

                        cacheT[yCursor] = sNewText
                        cacheFG[yCursor] = sNewTextColor
                        cacheBG[yCursor] = sNewBackgroundColor
                    end
                end
                xCursor = nEnd + 1
                if (visible) then
                    updateCursor()
                end
            end
        end

        local function setText(_x, _y, text)
            if (text ~= nil) then
                local gText = cacheT[_y]
                if (gText ~= nil) then
                    cacheT[_y] = sub(gText:sub(1, _x - 1) .. text .. gText:sub(_x + (text:len()), width), 1, width)
                end
            end
        end

        local function setBG(_x, _y, colorStr)
            if (colorStr ~= nil) then
                local gBG = cacheBG[_y]
                if (gBG ~= nil) then
                    cacheBG[_y] = sub(gBG:sub(1, _x - 1) .. colorStr .. gBG:sub(_x + (colorStr:len()), width), 1, width)
                end
            end
        end

        local function setFG(_x, _y, colorStr)
            if (colorStr ~= nil) then
                local gFG = cacheFG[_y]
                if (gFG ~= nil) then
                    cacheFG[_y] = sub(gFG:sub(1, _x - 1) .. colorStr .. gFG:sub(_x + (colorStr:len()), width), 1, width)
                end
            end
        end

        local setTextColor = function(color)
            if type(color) ~= "number" then
                error("bad argument #1 (expected number, got " .. type(color) .. ")", 2)
            elseif tHex[color] == nil then
                error("Invalid color (got " .. color .. ")", 2)
            end
            fgColor = color
        end

        local setBackgroundColor = function(color)
            if type(color) ~= "number" then
                error("bad argument #1 (expected number, got " .. type(color) .. ")", 2)
            elseif tHex[color] == nil then
                error("Invalid color (got " .. color .. ")", 2)
            end
            bgColor = color
        end

        local setPaletteColor = function(colour, r, g, b)
            -- have to work on
            if type(colour) ~= "number" then
                error("bad argument #1 (expected number, got " .. type(colour) .. ")", 2)
            end

            if tHex[colour] == nil then
                error("Invalid color (got " .. colour .. ")", 2)
            end

            local tCol
            if type(r) == "number" and g == nil and b == nil then
                tCol = { colours.rgb8(r) }
                tPalette[colour] = tCol
            else
                if type(r) ~= "number" then
                    error("bad argument #2 (expected number, got " .. type(r) .. ")", 2)
                end
                if type(g) ~= "number" then
                    error("bad argument #3 (expected number, got " .. type(g) .. ")", 2)
                end
                if type(b) ~= "number" then
                    error("bad argument #4 (expected number, got " .. type(b) .. ")", 2)
                end

                tCol = tPalette[colour]
                tCol[1] = r
                tCol[2] = g
                tCol[3] = b
            end
        end

        local getPaletteColor = function(colour)
            if type(colour) ~= "number" then
                error("bad argument #1 (expected number, got " .. type(colour) .. ")", 2)
            end
            if tHex[colour] == nil then
                error("Invalid color (got " .. colour .. ")", 2)
            end
            local tCol = tPalette[colour]
            return tCol[1], tCol[2], tCol[3]
        end

        local basaltwindow = {
            setCursorPos = function(_x, _y)
                if type(_x) ~= "number" then
                    error("bad argument #1 (expected number, got " .. type(_x) .. ")", 2)
                end
                if type(_y) ~= "number" then
                    error("bad argument #2 (expected number, got " .. type(_y) .. ")", 2)
                end
                xCursor = math.floor(_x)
                yCursor = math.floor(_y)
                if (visible) then
                    updateCursor()
                end
            end;

            getCursorPos = function()
                return xCursor, yCursor
            end;

            setCursorBlink = function(blink)
                if type(blink) ~= "boolean" then
                    error("bad argument #1 (expected boolean, got " .. type(blink) .. ")", 2)
                end
                cursorBlink = blink
            end;

            getCursorBlink = function()
                return cursorBlink
            end;


            getPaletteColor = getPaletteColor,
            getPaletteColour = getPaletteColor,

            setBackgroundColor = setBackgroundColor,
            setBackgroundColour = setBackgroundColor,

            setTextColor = setTextColor,
            setTextColour = setTextColor,

            setPaletteColor = setPaletteColor,
            setPaletteColour = setPaletteColor,

            getBackgroundColor = function()
                return bgColor
            end;
            getBackgroundColour = function()
                return bgColor
            end;

            getSize = function()
                return width, height
            end;

            getTextColor = function()
                return fgColor
            end;
            getTextColour = function()
                return fgColor
            end;

            basalt_resize = function(_width, _height)
                width, height = _width, _height
                recreateWindowArray()
            end;

            basalt_reposition = function(_x, _y)
                x, y = _x, _y
            end;

            basalt_setVisible = function(vis)
                visible = vis
            end;

            drawBackgroundBox = function(_x, _y, _width, _height, bgCol)
                for n = 1, _height do
                    setBG(_x, _y + (n - 1), tHex[bgCol]:rep(_width))
                end
            end;
            drawForegroundBox = function(_x, _y, _width, _height, fgCol)
                for n = 1, _height do
                    setFG(_x, _y + (n - 1), tHex[fgCol]:rep(_width))
                end
            end;
            drawTextBox = function(_x, _y, _width, _height, symbol)
                for n = 1, _height do
                    setText(_x, _y + (n - 1), symbol:rep(_width))
                end
            end;

            writeText = function(_x, _y, text, bgCol, fgCol)
                bgCol = bgCol or bgColor
                fgCol = fgCol or fgColor
                setText(x, _y, text)
                setBG(_x, _y, tHex[bgCol]:rep(text:len()))
                setFG(_x, _y, tHex[fgCol]:rep(text:len()))
            end;

            basalt_update = function()
                if (object.parent ~= nil) then
                    for n = 1, height do
                        object.parent:setText(x, y + (n - 1), cacheT[n])
                        object.parent:setBG(x, y + (n - 1), cacheBG[n])
                        object.parent:setFG(x, y + (n - 1), cacheFG[n])
                    end
                end
            end;

            scroll = function(offset)
                if type(offset) ~= "number" then
                    error("bad argument #1 (expected number, got " .. type(offset) .. ")", 2)
                end
                if offset ~= 0 then
                    local sEmptyText = emptySpaceLine
                    local sEmptyTextColor = emptyColorLines[fgColor]
                    local sEmptyBackgroundColor = emptyColorLines[bgColor]
                    for newY = 1, height do
                        local y = newY + offset
                        if y >= 1 and y <= height then
                            cacheT[newY] = cacheT[y]
                            cacheBG[newY] = cacheBG[y]
                            cacheFG[newY] = cacheFG[y]
                        else
                            cacheT[newY] = sEmptyText
                            cacheFG[newY] = sEmptyTextColor
                            cacheBG[newY] = sEmptyBackgroundColor
                        end
                    end
                end
                if (visible) then
                    updateCursor()
                end
            end;


            isColor = function()
                return parentTerminal.isColor()
            end;

            isColour = function()
                return parentTerminal.isColor()
            end;

            write = function(text)
                text = tostring(text)
                if (visible) then
                    internalBlit(text, tHex[fgColor]:rep(text:len()), tHex[bgColor]:rep(text:len()))
                end
            end;

            clearLine = function()
                if (visible) then
                    setText(1, yCursor, (" "):rep(width))
                    setBG(1, yCursor, tHex[bgColor]:rep(width))
                    setFG(1, yCursor, tHex[fgColor]:rep(width))
                end
                if (visible) then
                    updateCursor()
                end
            end;

            clear = function()
                for n = 1, height do
                    setText(1, n, (" "):rep(width))
                    setBG(1, n, tHex[bgColor]:rep(width))
                    setFG(1, n, tHex[fgColor]:rep(width))
                end
                if (visible) then
                    updateCursor()
                end
            end;

            blit = function(text, fgcol, bgcol)
                if type(text) ~= "string" then
                    error("bad argument #1 (expected string, got " .. type(text) .. ")", 2)
                end
                if type(fgcol) ~= "string" then
                    error("bad argument #2 (expected string, got " .. type(fgcol) .. ")", 2)
                end
                if type(bgcol) ~= "string" then
                    error("bad argument #3 (expected string, got " .. type(bgcol) .. ")", 2)
                end
                if #fgcol ~= #text or #bgcol ~= #text then
                    error("Arguments must be the same length", 2)
                end
                if (visible) then
                    --setText(xCursor, yCursor, text)
                    --setBG(xCursor, yCursor, bgcol)
                    --setFG(xCursor, yCursor, fgcol)
                    --xCursor = xCursor+text:len()
                    internalBlit(text, fgcol, bgcol)
                end
            end


        }

        return basaltwindow
    end

    base.width = 30
    base.height = 12
    local pWindow = createBasaltWindow(1, 1, base.width, base.height)
    local curProcess
    local paused = false
    local queuedEvent = {}

    object = {
        getType = function(self)
            return objectType
        end;

        show = function(self)
            base.show(self)
            pWindow.setBackgroundColor(self.bgColor)
            pWindow.setTextColor(self.fgColor)
            pWindow.basalt_setVisible(true)
            return self
        end;

        hide = function(self)
            base.hide(self)
            pWindow.basalt_setVisible(false)
            return self
        end;

        setPosition = function(self, x, y, rel)
            base.setPosition(self, x, y, rel)
            pWindow.basalt_reposition(self:getAnchorPosition())
            return self
        end;

        getBasaltWindow = function()
            return pWindow
        end;

        getBasaltProcess = function()
            return curProcess
        end;

        setSize = function(self, width, height)
            base.setSize(self, width, height)
            pWindow.basalt_resize(self.width, self.height)
            return self
        end;

        getStatus = function(self)
            if (curProcess ~= nil) then
                return curProcess:getStatus()
            end
            return "inactive"
        end;

        execute = function(self, path, ...)
            curProcess = process:new(path, pWindow, ...)
            pWindow.setBackgroundColor(colors.black)
            pWindow.setTextColor(colors.white)
            pWindow.clear()
            pWindow.setCursorPos(1, 1)
            curProcess:resume()
            paused = false
            return self
        end;

        stop = function(self)
            if (curProcess ~= nil) then
                if not (curProcess:isDead()) then
                    curProcess:resume("terminate")
                    if (curProcess:isDead()) then
                        if (self.parent ~= nil) then
                            self.parent:setCursor(false)
                        end
                    end
                end
            end
            return self
        end;

        pause = function(self, p)
            paused = p or (not paused)
            if (curProcess ~= nil) then
                if not (curProcess:isDead()) then
                    if not (paused) then
                        self:injectEvents(queuedEvent)
                        queuedEvent = {}
                    end
                end
            end
            return self
        end;

        isPaused = function(self)
            return paused
        end;

        injectEvent = function(self, event, p1, p2, p3, p4, ign)
            if (curProcess ~= nil) then
                if not (curProcess:isDead()) then
                    if (paused == false) or (ign) then
                        curProcess:resume(event, p1, p2, p3, p4)
                    else
                        table.insert(queuedEvent, { event = event, args = { p1, p2, p3, p4 } })
                    end
                end
            end
            return self
        end;

        getQueuedEvents = function(self)
            return queuedEvent
        end;

        updateQueuedEvents = function(self, events)
            queuedEvent = events or queuedEvent
            return self
        end;

        injectEvents = function(self, events)
            if (curProcess ~= nil) then
                if not (curProcess:isDead()) then
                    for _, value in pairs(events) do
                        curProcess:resume(value.event, table.unpack(value.args))
                    end
                end
            end
            return self
        end;

        mouseHandler = function(self, event, button, x, y)
            if (base.mouseHandler(self, event, button, x, y)) then
                if (curProcess == nil) then
                    return false
                end
                if not (curProcess:isDead()) then
                    if not (paused) then
                        local absX, absY = self:getAbsolutePosition(self:getAnchorPosition(nil, nil, true))
                        curProcess:resume(event, button, x - (absX - 1), y - (absY - 1))
                        basalt.debug(event, button, x - (absX - 1), y - (absY - 1))
                    end
                end
                return true
            end
        end;

        keyHandler = function(self, event, key)
            base.keyHandler(self, event, key)
            if (self:isFocused()) then
                if (curProcess == nil) then
                    return false
                end
                if not (curProcess:isDead()) then
                    if not (paused) then
                        if (self.draw) then
                            curProcess:resume(event, key)
                        end
                    end
                end
            end
        end;

        getFocusHandler = function(self)
            base.getFocusHandler(self)
            if (curProcess ~= nil) then
                if not (curProcess:isDead()) then
                    if not (paused) then
                        if (self.parent ~= nil) then
                            local xCur, yCur = pWindow.getCursorPos()
                            local obx, oby = self:getAnchorPosition()
                            if (self.parent ~= nil) then
                                if (obx + xCur - 1 >= 1 and obx + xCur - 1 <= obx + self.width - 1 and yCur + oby - 1 >= 1 and yCur + oby - 1 <= oby + self.height - 1) then
                                    self.parent:setCursor(pWindow.getCursorBlink(), obx + xCur - 1, yCur + oby - 1, pWindow.getTextColor())
                                end
                            end
                        end
                    end
                end
            end
        end;

        loseFocusHandler = function(self)
            base.loseFocusHandler(self)
            if (curProcess ~= nil) then
                if not (curProcess:isDead()) then
                    if (self.parent ~= nil) then
                        self.parent:setCursor(false)
                    end
                end
            end
        end;

        eventHandler = function(self, event, p1, p2, p3, p4)
            if (curProcess == nil) then
                return
            end
            if not (curProcess:isDead()) then
                if not (paused) then
                    if (event ~= "mouse_click") and (event ~= "monitor_touch") and (event ~= "mouse_up") and (event ~= "mouse_scroll") and (event ~= "mouse_drag") and (event ~= "key_up") and (event ~= "key") and (event ~= "char") and (event ~= "terminate") then
                        curProcess:resume(event, p1, p2, p3, p4)
                    end
                    if (self:isFocused()) then
                        local obx, oby = self:getAnchorPosition()
                        local xCur, yCur = pWindow.getCursorPos()
                        if (self.parent ~= nil) then
                            if (obx + xCur - 1 >= 1 and obx + xCur - 1 <= obx + self.width - 1 and yCur + oby - 1 >= 1 and yCur + oby - 1 <= oby + self.height - 1) then
                                self.parent:setCursor(pWindow.getCursorBlink(), obx + xCur - 1, yCur + oby - 1, pWindow.getTextColor())
                            end
                        end

                        if (event == "terminate") and (self:isFocused()) then
                            self:stop()
                        end
                    end
                else
                    if (event ~= "mouse_click") and (event ~= "monitor_touch") and (event ~= "mouse_up") and (event ~= "mouse_scroll") and (event ~= "mouse_drag") and (event ~= "key_up") and (event ~= "key") and (event ~= "char") and (event ~= "terminate") then
                        table.insert(queuedEvent, { event = event, args = { p1, p2, p3, p4 } })
                    end
                end
            end
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    pWindow.basalt_reposition(obx, oby)
                    if(self.bgColor~=false)then
                        self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                    end
                    pWindow.basalt_update()
                end
                self:setVisualChanged(false)
            end
        end;

    }

    return setmetatable(object, base)
end
local function Progressbar(name)
    -- Checkbox
    local base = Object(name)
    local objectType = "Progressbar"

    local progress = 0

    base:setZIndex(5)
    base:setValue(false)
    base.width = 25
    base.height = 1
    base.bgColor = theme.CheckboxBG
    base.fgColor = theme.CheckboxFG

    local activeBarColor = colors.black
    local activeBarSymbol = ""
    local activeBarSymbolCol = colors.white
    local bgBarSymbol = ""
    local direction = 0

    local object = {

        getType = function(self)
            return objectType
        end;

        setDirection = function(self, dir)
            direction = dir
            return self
        end;

        setProgressBar = function(self, color, symbol, symbolcolor)
            activeBarColor = color or activeBarColor
            activeBarSymbol = symbol or activeBarSymbol
            activeBarSymbolCol = symbolcolor or activeBarSymbolCol
            return self
        end;

        setBackgroundSymbol = function(self, symbol)
            bgBarSymbol = symbol:sub(1, 1)
            return self
        end;

        setProgress = function(self, value)
            if (value >= 0) and (value <= 100) and (progress ~= value) then
                progress = value
                self:setValue(progress)
                if (progress == 100) then
                    self:progressDoneHandler()
                end
            end
            return self
        end;

        getProgress = function(self)
            return progress
        end;

        onProgressDone = function(self, f)
            self:registerEvent("progress_done", f)
            return self
        end;

        progressDoneHandler = function(self)
            self:sendEvent("progress_done", self)
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                    self.parent:drawForegroundBox(obx, oby, self.width, self.height, self.fgColor)
                    self.parent:drawTextBox(obx, oby, self.width, self.height, bgBarSymbol)
                    if (direction == 1) then
                        self.parent:drawBackgroundBox(obx, oby, self.width, self.height / 100 * progress, activeBarColor)
                        self.parent:drawForegroundBox(obx, oby, self.width, self.height / 100 * progress, activeBarSymbolCol)
                        self.parent:drawTextBox(obx, oby, self.width, self.height / 100 * progress, activeBarSymbol)
                    elseif (direction == 2) then
                        self.parent:drawBackgroundBox(obx, oby + math.ceil(self.height - self.height / 100 * progress), self.width, self.height / 100 * progress, activeBarColor)
                        self.parent:drawForegroundBox(obx, oby + math.ceil(self.height - self.height / 100 * progress), self.width, self.height / 100 * progress, activeBarSymbolCol)
                        self.parent:drawTextBox(obx, oby + math.ceil(self.height - self.height / 100 * progress), self.width, self.height / 100 * progress, activeBarSymbol)
                    elseif (direction == 3) then
                        self.parent:drawBackgroundBox(obx + math.ceil(self.width - self.width / 100 * progress), oby, self.width / 100 * progress, self.height, activeBarColor)
                        self.parent:drawForegroundBox(obx + math.ceil(self.width - self.width / 100 * progress), oby, self.width / 100 * progress, self.height, activeBarSymbolCol)
                        self.parent:drawTextBox(obx + math.ceil(self.width - self.width / 100 * progress), oby, self.width / 100 * progress, self.height, activeBarSymbol)
                    else
                        self.parent:drawBackgroundBox(obx, oby, self.width / 100 * progress, self.height, activeBarColor)
                        self.parent:drawForegroundBox(obx, oby, self.width / 100 * progress, self.height, activeBarSymbolCol)
                        self.parent:drawTextBox(obx, oby, self.width / 100 * progress, self.height, activeBarSymbol)
                    end
                end
                self:setVisualChanged(false)
            end
        end;

    }

    return setmetatable(object, base)
end
local function Radio(name)
    local base = Object(name)
    local objectType = "Radio"
    base.width = 8
    base.bgColor = theme.listBG
    base.fgColor = theme.listFG
    base:setZIndex(5)

    local list = {}
    local itemSelectedBG = theme.selectionBG
    local itemSelectedFG = theme.selectionFG
    local boxSelectedBG = base.bgColor
    local boxSelectedFG = base.fgColor
    local selectionColorActive = true
    local symbol = "\7"
    local align = "left"

    local object = {
        getType = function(self)
            return objectType
        end;

        addItem = function(self, text, x, y, bgCol, fgCol, ...)
            table.insert(list, { x = x or 1, y = y or 1, text = text, bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            if (#list == 1) then
                self:setValue(list[1])
            end
            return self
        end;

        getAll = function(self)
            return list
        end;

        removeItem = function(self, index)
            table.remove(list, index)
            return self
        end;

        getItem = function(self, index)
            return list[index]
        end;

        getItemIndex = function(self)
            local selected = self:getValue()
            for key, value in pairs(list) do
                if (value == selected) then
                    return key
                end
            end
        end;

        clear = function(self)
            list = {}
            self:setValue({})
            return self
        end;

        getItemCount = function(self)
            return #list
        end;

        editItem = function(self, index, text, x, y, bgCol, fgCol, ...)
            table.remove(list, index)
            table.insert(list, index, { x = x or 1, y = y or 1, text = text, bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            return self
        end;

        selectItem = function(self, index)
            self:setValue(list[index] or {})
            return self
        end;

        setSelectedItem = function(self, bgCol, fgCol, boxBG, boxFG, active)
            itemSelectedBG = bgCol or itemSelectedBG
            itemSelectedFG = fgCol or itemSelectedFG
            boxSelectedBG = boxBG or boxSelectedBG
            boxSelectedFG = boxFG or boxSelectedFG
            selectionColorActive = active
            return self
        end;

        mouseHandler = function(self, event, button, x, y)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            if ((event == "mouse_click")and(button==1))or(event=="monitor_touch") then
                if (#list > 0) then
                    for _, value in pairs(list) do
                        if (obx + value.x - 1 <= x) and (obx + value.x - 1 + value.text:len() + 2 >= x) and (oby + value.y - 1 == y) then
                            self:setValue(value)
                            if (self.parent ~= nil) then
                                self.parent:setFocusedObject(self)
                            end
                            --eventSystem:sendEvent(event, self, event, button, x, y)
                            self:setVisualChanged()
                            return true
                        end
                    end
                end
            end
            return false
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    for _, value in pairs(list) do
                        if (value == self:getValue()) then
                            if (align == "left") then
                                self.parent:writeText(value.x + obx - 1, value.y + oby - 1, symbol, boxSelectedBG, boxSelectedFG)
                                self.parent:writeText(value.x + 2 + obx - 1, value.y + oby - 1, value.text, itemSelectedBG, itemSelectedFG)
                            end
                        else
                            self.parent:drawBackgroundBox(value.x + obx - 1, value.y + oby - 1, 1, 1, self.bgColor)
                            self.parent:writeText(value.x + 2 + obx - 1, value.y + oby - 1, value.text, value.bgCol, value.fgCol)
                        end
                    end
                end
                self:setVisualChanged(false)
            end
        end;
    }

    return setmetatable(object, base)
end
local function Scrollbar(name)
    local base = Object(name)
    local objectType = "Scrollbar"

    base.width = 1
    base.height = 8
    base.bgColor = colors.lightGray
    base.fgColor = colors.gray
    base:setValue(1)
    base:setZIndex(2)

    local barType = "vertical"
    local symbol = " "
    local symbolColor = colors.black
    local bgSymbol = "\127"
    local maxValue = base.height
    local index = 1
    local symbolSize = 1

    local object = {
        getType = function(self)
            return objectType
        end;

        setSymbol = function(self, _symbol)
            symbol = _symbol:sub(1, 1)
            self:setVisualChanged()
            return self
        end;

        setSymbolSize = function(self, size)
            symbolSize = tonumber(size) or 1
            if (barType == "vertical") then
                self:setValue(index - 1 * (maxValue / (self.height - (symbolSize - 1))) - (maxValue / (self.height - (symbolSize - 1))))
            elseif (barType == "horizontal") then
                self:setValue(index - 1 * (maxValue / (self.width - (symbolSize - 1))) - (maxValue / (self.width - (symbolSize - 1))))
            end
            self:setVisualChanged()
            return self
        end;

        setMaxValue = function(self, val)
            maxValue = val
            return self
        end;

        setBackgroundSymbol = function(self, _bgSymbol)
            bgSymbol = string.sub(_bgSymbol, 1, 1)
            self:setVisualChanged()
            return self
        end;

        setSymbolColor = function(self, col)
            symbolColor = col
            self:setVisualChanged()
            return self
        end;

        setBarType = function(self, _typ)
            barType = _typ:lower()
            return self
        end;

        mouseHandler = function(self, event, button, x, y)
            if (base.mouseHandler(self, event, button, x, y)) then
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                if (((event == "mouse_click") or (event == "mouse_drag")) and (button == 1))or(event=="monitor_touch") then
                    if (barType == "horizontal") then
                        for _index = 0, self.width do
                            if (obx + _index == x) and (oby <= y) and (oby + self.height > y) then
                                index = math.min(_index + 1, self.width - (symbolSize - 1))
                                self:setValue(maxValue / self.width * (index))
                                self:setVisualChanged()
                            end
                        end
                    end
                    if (barType == "vertical") then
                        for _index = 0, self.height do
                            if (oby + _index == y) and (obx <= x) and (obx + self.width > x) then
                                index = math.min(_index + 1, self.height - (symbolSize - 1))
                                self:setValue(maxValue / self.height * (index))
                                self:setVisualChanged()
                            end
                        end
                    end
                end
                if (event == "mouse_scroll") then
                    index = index + button
                    if (index < 1) then
                        index = 1
                    end
                    index = math.min(index, (barType == "vertical" and self.height or self.width) - (symbolSize - 1))
                    self:setValue(maxValue / (barType == "vertical" and self.height or self.width) * index)
                end
                return true
            end
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    if (barType == "horizontal") then
                        self.parent:writeText(obx, oby, bgSymbol:rep(index - 1), self.bgColor, self.fgColor)
                        self.parent:writeText(obx + index - 1, oby, symbol:rep(symbolSize), symbolColor, symbolColor)
                        self.parent:writeText(obx + index + symbolSize - 1, oby, bgSymbol:rep(self.width - (index + symbolSize - 1)), self.bgColor, self.fgColor)
                    end

                    if (barType == "vertical") then
                        for n = 0, self.height - 1 do

                            if (index == n + 1) then
                                for curIndexOffset = 0, math.min(symbolSize - 1, self.height) do
                                    self.parent:writeText(obx, oby + n + curIndexOffset, symbol, symbolColor, symbolColor)
                                end
                            else
                                if (n + 1 < index) or (n + 1 > index - 1 + symbolSize) then
                                    self.parent:writeText(obx, oby + n, bgSymbol, self.bgColor, self.fgColor)
                                end
                            end
                        end
                    end
                end
                self:setVisualChanged(false)
            end
        end;
    }

    return setmetatable(object, base)
end
local function Slider(name)
    local base = Object(name)
    local objectType = "Slider"

    base.width = 8
    base.height = 1
    base.bgColor = colors.lightGray
    base.fgColor = colors.gray
    base:setValue(1)

    local barType = "horizontal"
    local symbol = " "
    local symbolColor = colors.black
    local bgSymbol = "\140"
    local maxValue = base.width
    local index = 1
    local symbolSize = 1

    local object = {
        getType = function(self)
            return objectType
        end;

        setSymbol = function(self, _symbol)
            symbol = _symbol:sub(1, 1)
            self:setVisualChanged()
            return self
        end;

        setSymbolSize = function(self, size)
            symbolSize = tonumber(size) or 1
            if (barType == "vertical") then
                self:setValue(index - 1 * (maxValue / (self.height - (symbolSize - 1))) - (maxValue / (self.height - (symbolSize - 1))))
            elseif (barType == "horizontal") then
                self:setValue(index - 1 * (maxValue / (self.width - (symbolSize - 1))) - (maxValue / (self.width - (symbolSize - 1))))
            end
            self:setVisualChanged()
            return self
        end;

        setMaxValue = function(self, val)
            maxValue = val
            return self
        end;

        setBackgroundSymbol = function(self, _bgSymbol)
            bgSymbol = string.sub(_bgSymbol, 1, 1)
            self:setVisualChanged()
            return self
        end;

        setSymbolColor = function(self, col)
            symbolColor = col
            self:setVisualChanged()
            return self
        end;

        setBarType = function(self, _typ)
            barType = _typ:lower()
            return self
        end;

        mouseHandler = function(self, event, button, x, y)
            if (base.mouseHandler(self, event, button, x, y)) then
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                if (((event == "mouse_click") or (event == "mouse_drag")) and (button == 1))or(event=="monitor_touch") then
                    if (barType == "horizontal") then
                        for _index = 0, self.width do
                            if (obx + _index == x) and (oby <= y) and (oby + self.height > y) then
                                index = math.min(_index + 1, self.width - (symbolSize - 1))
                                self:setValue(maxValue / self.width * (index))
                                self:setVisualChanged()
                            end
                        end
                    end
                    if (barType == "vertical") then
                        for _index = 0, self.height do
                            if (oby + _index == y) and (obx <= x) and (obx + self.width > x) then
                                index = math.min(_index + 1, self.height - (symbolSize - 1))
                                self:setValue(maxValue / self.height * (index))
                                self:setVisualChanged()
                            end
                        end
                    end
                end
                if (event == "mouse_scroll") then
                    index = index + button
                    if (index < 1) then
                        index = 1
                    end
                    index = math.min(index, (barType == "vertical" and self.height or self.width) - (symbolSize - 1))
                    self:setValue(maxValue / (barType == "vertical" and self.height or self.width) * index)
                end
                return true
            end
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    if (barType == "horizontal") then
                        self.parent:writeText(obx, oby, bgSymbol:rep(index - 1), self.bgColor, self.fgColor)
                        self.parent:writeText(obx + index - 1, oby, symbol:rep(symbolSize), symbolColor, symbolColor)
                        self.parent:writeText(obx + index + symbolSize - 1, oby, bgSymbol:rep(self.width - (index + symbolSize - 1)), self.bgColor, self.fgColor)
                    end

                    if (barType == "vertical") then
                        for n = 0, self.height - 1 do

                            if (index == n + 1) then
                                for curIndexOffset = 0, math.min(symbolSize - 1, self.height) do
                                    self.parent:writeText(obx, oby + n + curIndexOffset, symbol, symbolColor, symbolColor)
                                end
                            else
                                if (n + 1 < index) or (n + 1 > index - 1 + symbolSize) then
                                    self.parent:writeText(obx, oby + n, bgSymbol, self.bgColor, self.fgColor)
                                end
                            end
                        end
                    end
                end
                self:setVisualChanged(false)
            end
        end;
    }

    return setmetatable(object, base)
end
local function Switch(name)
    local base = Object(name)
    local objectType = "Switch"

    base.width = 2
    base.height = 1
    base.bgColor = colors.lightGray
    base.fgColor = colors.gray
    base:setValue(false)
    base:setZIndex(5)

    local bgSymbol = colors.black
    local inactiveBG = colors.red
    local activeBG = colors.green

    local object = {
        getType = function(self)
            return objectType
        end;

        setSymbolColor = function(self, symbolColor)
            bgSymbol = symbolColor
            self:setVisualChanged()
            return self
        end;

        setActiveBackground = function(self, bgcol)
            activeBG = bgcol
            self:setVisualChanged()
            return self
        end;

        setInactiveBackground = function(self, bgcol)
            inactiveBG = bgcol
            self:setVisualChanged()
            return self
        end;

        mouseHandler = function(self, event, button, x, y)
            if (base.mouseHandler(self, event, button, x, y)) then
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                if ((event == "mouse_click") and (button == 1))or(event=="monitor_touch") then
                    self:setValue(not self:getValue())
                end
                return true
            end
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                    if(self:getValue())then
                        self.parent:drawBackgroundBox(obx, oby, 1, self.height, activeBG)
                        self.parent:drawBackgroundBox(obx+1, oby, 1, self.height, bgSymbol)
                    else
                        self.parent:drawBackgroundBox(obx, oby, 1, self.height, bgSymbol)
                        self.parent:drawBackgroundBox(obx+1, oby, 1, self.height, inactiveBG)
                    end
                end
                self:setVisualChanged(false)
            end
        end;
    }

    return setmetatable(object, base)
end
local function Textfield(name)
    local base = Object(name)
    local objectType = "Textfield"
    local hIndex, wIndex, textX, textY = 1, 1, 1, 1

    local lines = { "" }
    local keyWords = { [colors.purple] = { "break" } }

    base.width = 20
    base.height = 8
    base.bgColor = theme.textfieldBG
    base.fgColor = theme.textfieldFG
    base:setZIndex(5)

    local object = {
        getType = function(self)
            return objectType
        end;

        getLines = function(self)
            return lines
        end;

        getLine = function(self, index)
            return lines[index] or ""
        end;

        editLine = function(self, index, text)
            lines[index] = text or lines[index]
            return self
        end;

        addLine = function(self, text, index)
            if (index ~= nil) then
                table.insert(lines, index, text)
            else
                table.insert(lines, text)
            end
            return self
        end;

        addKeyword = function(self, keyword, color)

        end;

        removeLine = function(self, index)
            table.remove(lines, index or #lines)
            if (#lines <= 0) then
                table.insert(lines, "")
            end
            return self
        end;

        getTextCursor = function(self)
            return textX, textY
        end;

        getFocusHandler = function(self)
            base.getFocusHandler(self)
            if (self.parent ~= nil) then
                local obx, oby = self:getAnchorPosition()
                if (self.parent ~= nil) then
                    self.parent:setCursor(true, obx + textX - wIndex, oby + textY - hIndex, self.fgColor)
                end
            end
        end;

        loseFocusHandler = function(self)
            base.loseFocusHandler(self)
            if (self.parent ~= nil) then
                self.parent:setCursor(false)
            end
        end;

        keyHandler = function(self, event, key)
            if (base.keyHandler(self, event, key)) then
                local obx, oby = self:getAnchorPosition()
                if (event == "key") then
                    if (key == keys.backspace) then
                        -- on backspace
                        if (lines[textY] == "") then
                            if (textY > 1) then
                                table.remove(lines, textY)
                                textX = lines[textY - 1]:len() + 1
                                wIndex = textX - self.width + 1
                                if (wIndex < 1) then
                                    wIndex = 1
                                end
                                textY = textY - 1
                            end
                        elseif (textX <= 1) then
                            if (textY > 1) then
                                textX = lines[textY - 1]:len() + 1
                                wIndex = textX - self.width + 1
                                if (wIndex < 1) then
                                    wIndex = 1
                                end
                                lines[textY - 1] = lines[textY - 1] .. lines[textY]
                                table.remove(lines, textY)
                                textY = textY - 1
                            end
                        else
                            lines[textY] = lines[textY]:sub(1, textX - 2) .. lines[textY]:sub(textX, lines[textY]:len())
                            if (textX > 1) then
                                textX = textX - 1
                            end
                            if (wIndex > 1) then
                                if (textX < wIndex) then
                                    wIndex = wIndex - 1
                                end
                            end
                        end
                        if (textY < hIndex) then
                            hIndex = hIndex - 1
                        end
                        self:setValue("")
                    end

                    if (key == keys.delete) then
                        -- on delete
                        if (textX > lines[textY]:len()) then
                            if (lines[textY + 1] ~= nil) then
                                lines[textY] = lines[textY] .. lines[textY + 1]
                                table.remove(lines, textY + 1)
                            end
                        else
                            lines[textY] = lines[textY]:sub(1, textX - 1) .. lines[textY]:sub(textX + 1, lines[textY]:len())
                        end
                    end

                    if (key == keys.enter) then
                        -- on enter
                        table.insert(lines, textY + 1, lines[textY]:sub(textX, lines[textY]:len()))
                        lines[textY] = lines[textY]:sub(1, textX - 1)
                        textY = textY + 1
                        textX = 1
                        wIndex = 1
                        if (textY - hIndex >= self.height) then
                            hIndex = hIndex + 1
                        end
                        self:setValue("")
                    end

                    if (key == keys.up) then
                        -- arrow up
                        if (textY > 1) then
                            textY = textY - 1
                            if (textX > lines[textY]:len() + 1) then
                                textX = lines[textY]:len() + 1
                            end
                            if (wIndex > 1) then
                                if (textX < wIndex) then
                                    wIndex = textX - self.width + 1
                                    if (wIndex < 1) then
                                        wIndex = 1
                                    end
                                end
                            end
                            if (hIndex > 1) then
                                if (textY < hIndex) then
                                    hIndex = hIndex - 1
                                end
                            end
                        end
                    end
                    if (key == keys.down) then
                        -- arrow down
                        if (textY < #lines) then
                            textY = textY + 1
                            if (textX > lines[textY]:len() + 1) then
                                textX = lines[textY]:len() + 1
                            end

                            if (textY >= hIndex + self.height) then
                                hIndex = hIndex + 1
                            end
                        end
                    end
                    if (key == keys.right) then
                        -- arrow right
                        textX = textX + 1
                        if (textY < #lines) then
                            if (textX > lines[textY]:len() + 1) then
                                textX = 1
                                textY = textY + 1
                            end
                        elseif (textX > lines[textY]:len()) then
                            textX = lines[textY]:len() + 1
                        end
                        if (textX < 1) then
                            textX = 1
                        end
                        if (textX < wIndex) or (textX >= self.width + wIndex) then
                            wIndex = textX - self.width + 1
                        end
                        if (wIndex < 1) then
                            wIndex = 1
                        end

                    end
                    if (key == keys.left) then
                        -- arrow left
                        textX = textX - 1
                        if (textX >= 1) then
                            if (textX < wIndex) or (textX >= self.width + wIndex) then
                                wIndex = textX
                            end
                        end
                        if (textY > 1) then
                            if (textX < 1) then
                                textY = textY - 1
                                textX = lines[textY]:len() + 1
                                wIndex = textX - self.width + 1
                            end
                        end
                        if (textX < 1) then
                            textX = 1
                        end
                        if (wIndex < 1) then
                            wIndex = 1
                        end
                    end
                end

                if (event == "char") then
                    lines[textY] = lines[textY]:sub(1, textX - 1) .. key .. lines[textY]:sub(textX, lines[textY]:len())
                    textX = textX + 1
                    if (textX >= self.width + wIndex) then
                        wIndex = wIndex + 1
                    end
                    self:setValue("")
                end

                local cursorX = (textX <= lines[textY]:len() and textX - 1 or lines[textY]:len()) - (wIndex - 1)
                if (cursorX > self.x + self.width - 1) then
                    cursorX = self.x + self.width - 1
                end
                local cursorY = (textY - hIndex < self.height and textY - hIndex or textY - hIndex - 1)
                if (cursorX < 1) then
                    cursorX = 0
                end
                self.parent:setCursor(true, obx + cursorX, oby + cursorY, self.fgColor)
                return true
            end
        end;

        mouseHandler = function(self, event, button, x, y)
            if (base.mouseHandler(self, event, button, x, y)) then
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                local anchx, anchy = self:getAnchorPosition()
                if (event == "mouse_click")or(event=="monitor_touch") then
                    if (lines[y - oby + hIndex] ~= nil) then
                        textX = x - obx + wIndex
                        textY = y - oby + hIndex
                        if (textX > lines[textY]:len()) then
                            textX = lines[textY]:len() + 1
                        end
                        if (textX < wIndex) then
                            wIndex = textX - 1
                            if (wIndex < 1) then
                                wIndex = 1
                            end
                        end
                        if (self.parent ~= nil) then
                            self.parent:setCursor(true, anchx + textX - wIndex, anchy + textY - hIndex, self.fgColor)
                        end
                    end
                end
                if (event == "mouse_drag") then
                    if (lines[y - oby + hIndex] ~= nil) then
                        textX = x - obx + wIndex
                        textY = y - oby + hIndex
                        if (textX > lines[textY]:len()) then
                            textX = lines[textY]:len() + 1
                        end
                        if (textX < wIndex) then
                            wIndex = textX - 1
                            if (wIndex < 1) then
                                wIndex = 1
                            end
                        end
                        if (self.parent ~= nil) then
                            self.parent:setCursor(true, anchx + textX - wIndex, anchy + textY - hIndex, self.fgColor)
                        end
                    end
                end

                if (event == "mouse_scroll") then
                    hIndex = hIndex + button
                    if (hIndex > #lines - (self.height - 1)) then
                        hIndex = #lines - (self.height - 1)
                    end

                    if (hIndex < 1) then
                        hIndex = 1
                    end

                    if (self.parent ~= nil) then
                        if (obx + textX - wIndex >= obx and obx + textX - wIndex <= obx + self.width) and (oby + textY - hIndex >= oby and oby + textY - hIndex <= oby + self.height) then
                            self.parent:setCursor(true, anchx + textX - wIndex, anchy + textY - hIndex, self.fgColor)
                        else
                            self.parent:setCursor(false)
                        end
                    end
                end
                self:setVisualChanged()
                return true
            end
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    if(self.bgColor~=false)then
                        self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                    end
                    if(self.fgColor~=false)then
                        self.parent:drawForegroundBox(obx, oby, self.width, self.height, self.fgColor)
                    end
                    for n = 1, self.height do
                        local text = ""
                        if (lines[n + hIndex - 1] ~= nil) then
                            text = lines[n + hIndex - 1]
                        end
                        text = text:sub(wIndex, self.width + wIndex - 1)
                        local space = self.width - text:len()
                        if (space < 0) then
                            space = 0
                        end
                        text = text .. string.rep(" ", space)
                        self.parent:setText(obx, oby + n - 1, text)
                    end
                end
                self:setVisualChanged(false)
            end
        end;
    }

    return setmetatable(object, base)
end
local function Thread(name)
    local object
    local objectType = "Thread"

    local func
    local cRoutine
    local isActive = false

    object = {
        name = name,
        getType = function(self)
            return objectType
        end;
        getZIndex = function(self)
            return 1
        end;
        getName = function(self)
            return self.name
        end;

        start = function(self, f)
            if (f == nil) then
                error("Function provided to thread is nil")
            end
            func = f
            cRoutine = coroutine.create(func)
            isActive = true
            local ok, result = coroutine.resume(cRoutine)
            if not (ok) then
                if (result ~= "Terminated") then
                    error("Thread Error Occurred - " .. result)
                end
            end
            return self
        end;

        getStatus = function(self, f)
            if (cRoutine ~= nil) then
                return coroutine.status(cRoutine)
            end
            return nil
        end;

        stop = function(self, f)
            isActive = false
            return self
        end;

        eventHandler = function(self, event, p1, p2, p3)
            if (isActive) then
                if (coroutine.status(cRoutine) ~= "dead") then
                    local ok, result = coroutine.resume(cRoutine, event, p1, p2, p3)
                    if not (ok) then
                        if (result ~= "Terminated") then
                            error("Thread Error Occurred - " .. result)
                        end
                    end
                else
                    isActive = false
                end
            end
        end;

    }

    object.__index = object

    return object
end
local function Timer(name)
    local objectType = "Timer"

    local timer = 0
    local savedRepeats = 0
    local repeats = 0
    local timerObj
    local eventSystem = BasaltEvents()
    local timerIsActive = false

    local object = {
        name = name,
        getType = function(self)
            return objectType
        end;

        getZIndex = function(self)
            return 1
        end;

        getName = function(self)
            return self.name
        end;

        setTime = function(self, _timer, _repeats)
            timer = _timer or 0
            savedRepeats = _repeats or 1
            return self
        end;

        start = function(self)
            if(timerIsActive)then
                os.cancelTimer(timerObj)
            end
            repeats = savedRepeats
            timerObj = os.startTimer(timer)
            timerIsActive = true
            return self
        end;

        isActive = function(self)
            return timerIsActive
        end;

        cancel = function(self)
            if (timerObj ~= nil) then
                os.cancelTimer(timerObj)
            end
            timerIsActive = false
            return self
        end;

        onCall = function(self, func)
            eventSystem:registerEvent("timed_event", func)
            return self
        end;

        eventHandler = function(self, event, tObj)
            if event == "timer" and tObj == timerObj and timerIsActive then
                eventSystem:sendEvent("timed_event", self)
                if (repeats >= 1) then
                    repeats = repeats - 1
                    if (repeats >= 1) then
                        timerObj = os.startTimer(timer)
                    end
                elseif (repeats == -1) then
                    timerObj = os.startTimer(timer)
                end
            end
        end;
    }
    object.__index = object

    return object
end
local function Frame(name, parent)
    -- Frame
    local base = Object(name)
    local objectType = "Frame"
    local objects = {}
    local objZIndex = {}
    local object = {}
    local termObject = parentTerminal

    local monSide = ""
    local isMonitor = false
    local monitorAttached = false
    local dragXOffset = 0
    local dragYOffset = 0

    base:setZIndex(10)

    local drawHelper = basaltDrawHelper(termObject)

    local cursorBlink = false
    local xCursor = 1
    local yCursor = 1
    local cursorColor = colors.white

    local xOffset, yOffset = 0, 0

    if (parent ~= nil) then
        base.parent = parent
        base.width, base.height = parent:getSize()
        base.bgColor = theme.FrameBG
        base.fgColor = theme.FrameFG
    else
        base.width, base.height = termObject.getSize()
        base.bgColor = theme.basaltBG
        base.fgColor = theme.basaltFG
    end

    local function getObject(name)
        for _, value in pairs(objects) do
            for _, b in pairs(value) do
                if (b.name == name) then
                    return value
                end
            end
        end
    end

    local function addObject(obj)
        local zIndex = obj:getZIndex()
        if (getObject(obj.name) ~= nil) then
            return nil
        end
        if (objects[zIndex] == nil) then
            for x = 1, #objZIndex + 1 do
                if (objZIndex[x] ~= nil) then
                    if (zIndex == objZIndex[x]) then
                        break
                    end
                    if (zIndex > objZIndex[x]) then
                        table.insert(objZIndex, x, zIndex)
                        break
                    end
                else
                    table.insert(objZIndex, zIndex)
                end
            end
            if (#objZIndex <= 0) then
                table.insert(objZIndex, zIndex)
            end
            objects[zIndex] = {}
        end
        obj.parent = object
        table.insert(objects[zIndex], obj)
        return obj
    end

    local function removeObject(obj)
        for a, b in pairs(objects) do
            for key, value in pairs(b) do
                if (value == obj) then
                    table.remove(objects[a], key)
                    return true;
                end
            end
        end
        return false
    end

    object = {
        barActive = false,
        barBackground = colors.gray,
        barTextcolor = colors.black,
        barText = "New Frame",
        barTextAlign = "left",
        isMoveable = false,

        getType = function(self)
            return objectType
        end;

        setFocusedObject = function(self, obj)
            if (focusedObject ~= nil) then
                focusedObject:loseFocusHandler()
                focusedObject = nil
            end
            if(obj~=nil)then
                focusedObject = obj
                obj:getFocusHandler()
            end
            return self
        end;

        setSize = function(self, w, h)
            base.setSize(self, w, h)
            for _, index in pairs(objZIndex) do
                if (objects[index] ~= nil) then
                    for _, value in pairs(objects[index]) do
                        if (value.eventHandler ~= nil) then
                            value:sendEvent("basalt_resize", value, self)
                        end
                    end
                end
            end
            return self
        end;

        setOffset = function(self, xO, yO)
            xOffset = xO ~= nil and math.floor(xO < 0 and math.abs(xO) or -xO) or xOffset
            yOffset = yO ~= nil and math.floor(yO < 0 and math.abs(yO) or -yO) or yOffset
            return self
        end;

        getFrameOffset = function(self) -- internal
            return xOffset, yOffset
        end;

        removeFocusedObject = function(self)
            if (focusedObject ~= nil) then
                focusedObject:loseFocusHandler()
            end
            focusedObject = nil
            return self
        end;

        getFocusedObject = function(self)
            return focusedObject
        end;

        setCursor = function(self, _blink, _xCursor, _yCursor, color)
            if(self.parent~=nil)then
                local obx, oby = self:getAnchorPosition()
                self.parent:setCursor(_blink or false, (_xCursor or 0)+obx-1, (_yCursor or 0)+oby-1, color or cursorColor)
            else
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                cursorBlink = _blink or false
                if (_xCursor ~= nil) then
                    xCursor = obx + _xCursor - 1
                end
                if (_yCursor ~= nil) then
                    yCursor = oby + _yCursor - 1
                end
                cursorColor = color or cursorColor
                self:setVisualChanged()
            end
            return self
        end;

        setMoveable = function(self, moveable)
            self.isMoveable = moveable or not self.isMoveable
            self:setVisualChanged()
            return self;
        end;

        show = function(self)
            base.show(self)
            if(self.parent==nil)then
                activeFrame = self;
                if(isMonitor)then
                    monFrames[monSide] = self;
                else
                    mainFrame = self;
                end
            end
            return self;
        end;

        hide = function (self)
            base.hide(self)
            if(self.parent==nil)then
                if(activeFrame == self)then activeFrame = nil end
                if(isMonitor)then
                    if(monFrames[monSide] == self)then
                        monFrames[monSide] = nil;
                    end
                else
                    if(mainFrame == self)then
                        mainFrame = nil;
                    end
                end
            end
            return self
        end;
        

        showBar = function(self, showIt)
            self.barActive = showIt or not self.barActive
            self:setVisualChanged()
            return self
        end;

        setBar = function(self, text, bgCol, fgCol)
            self.barText = text or ""
            self.barBackground = bgCol or self.barBackground
            self.barTextcolor = fgCol or self.barTextcolor
            self:setVisualChanged()
            return self
        end;

        setBarTextAlign = function(self, align)
            self.barTextAlign = align or "left"
            self:setVisualChanged()
            return self
        end;

        setMonitor = function(self, side)
            if(side~=nil)and(side~=false)then
                if(peripheral.getType(side)=="monitor")then
                    termObject = peripheral.wrap(side)
                    monitorAttached = true
                end
                isMonitor = true
            else
                termObject = parentTerminal
                isMonitor = false
                if(monFrames[monSide]==self)then
                    monFrames[monSide] = nil
                end
            end
            drawHelper = basaltDrawHelper(termObject)
            monSide = side or nil
            return self;
        end;

        getVisualChanged = function(self)
            local changed = base.getVisualChanged(self)
            for _, index in pairs(objZIndex) do
                if (objects[index] ~= nil) then
                    for _, value in pairs(objects[index]) do
                        if (value.getVisualChanged ~= nil and value:getVisualChanged()) then
                            changed = true
                        end
                    end
                end
            end
            return changed
        end;

        loseFocusHandler = function(self)
            base.loseFocusHandler(self)
        end;

        getFocusHandler = function(self)
            base.getFocusHandler(self)
            if (self.parent ~= nil) then
                self.parent:removeObject(self)
                self.parent:addObject(self)
            end
        end;

        keyHandler = function(self, event, key)
            if (focusedObject ~= nil) then
                if(focusedObject~=self)then
                    if (focusedObject.keyHandler ~= nil) then
                        if (focusedObject:keyHandler(event, key)) then
                            return true
                        end
                    end
                else
                    base.keyHandler(self, event, key)
                end
            end
            return false
        end;

        backgroundKeyHandler = function(self, event, key)
            base.backgroundKeyHandler(self, event, key)
            for _, index in pairs(objZIndex) do
                if (objects[index] ~= nil) then
                    for _, value in pairs(objects[index]) do
                        if (value.backgroundKeyHandler ~= nil) then
                            value:backgroundKeyHandler(event, key)
                        end
                    end
                end
            end
        end;

        eventHandler = function(self, event, p1, p2, p3, p4)
            base.eventHandler(self, event, p1, p2, p3, p4)
            for _, index in pairs(objZIndex) do
                if (objects[index] ~= nil) then
                    for _, value in pairs(objects[index]) do
                        if (value.eventHandler ~= nil) then
                            value:eventHandler(event, p1, p2, p3, p4)
                        end
                    end
                end
            end
            if(isMonitor)then
                if(event == "peripheral")and(p1==monSide)then
                    if(peripheral.getType(monSide)=="monitor")then
                        monitorAttached = true
                        termObject = peripheral.wrap(monSide)
                        drawHelper = basaltDrawHelper(termObject)
                    end
                end
                if(event == "peripheral_detach")and(p1==monSide)then
                    monitorAttached = false
                end
            end
            if (event == "terminate") then
                termObject.clear()
                termObject.setCursorPos(1, 1)
                basalt.stop()
            end
        end;

        mouseHandler = function(self, event, button, x, y)
            local xO, yO = self:getOffset()
            xO = xO < 0 and math.abs(xO) or -xO
            yO = yO < 0 and math.abs(yO) or -yO
            if (self.drag) then
                if (event == "mouse_drag") then
                    local parentX = 1;
                    local parentY = 1
                    if (self.parent ~= nil) then
                        parentX, parentY = self.parent:getAbsolutePosition(self.parent:getAnchorPosition())
                    end
                    self:setPosition(x + dragXOffset - (parentX - 1) + xO, y + dragYOffset - (parentY - 1) + yO)
                end
                if (event == "mouse_up") then
                    self.drag = false
                end
                return true
            end

            local objX, objY = self:getAbsolutePosition(self:getAnchorPosition())
            local yOff = false
            if(objY-1 == y)and(self:getBorder("top"))then
                y = y+1
                yOff = true
            end

            if (base.mouseHandler(self, event, button, x, y)) then
                local fx, fy = self:getAbsolutePosition(self:getAnchorPosition())
                fx = fx + xOffset;fy = fy + yOffset;
                    for _, index in pairs(objZIndex) do
                        if (objects[index] ~= nil) then
                            for _, value in rpairs(objects[index]) do
                                if (value.mouseHandler ~= nil) then
                                    if (value:mouseHandler(event, button, x, y)) then
                                        return true
                                    end
                                end
                            end
                        end
                    end
                    if (self.isMoveable) then
                        local fx, fy = self:getAbsolutePosition(self:getAnchorPosition())
                        if (x >= fx) and (x <= fx + self.width - 1) and (y == fy) and (event == "mouse_click") then
                            self.drag = true
                            dragXOffset = fx - x
                            dragYOffset = yOff and 1 or 0
                        end
                    end
                if (focusedObject ~= nil) then
                    focusedObject:loseFocusHandler()
                    focusedObject = nil
                end
                return true
            end
            return false
        end;

        setText = function(self, x, y, text)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            if (y >= 1) and (y <= self.height) then
                if (self.parent ~= nil) then
                    local parentX, parentY = self.parent:getAnchorPosition()
                    self.parent:setText(math.max(x + (obx - 1), obx) - (parentX - 1), oby + y - 1 - (parentY - 1), sub(text, math.max(1 - x + 1, 1), math.max(self.width - x + 1,1)))
                else
                    drawHelper.setText(math.max(x + (obx - 1), obx), oby + y - 1, sub(text, math.max(1 - x + 1, 1), math.max(self.width - x + 1,1))) -- math.max(self.width - x + 1,1) now, before: self.width - x + 1
                end
            end
        end;

        setBG = function(self, x, y, bgCol)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            if (y >= 1) and (y <= self.height) then
                if (self.parent ~= nil) then
                    local parentX, parentY = self.parent:getAnchorPosition()
                    self.parent:setBG(math.max(x + (obx - 1), obx) - (parentX - 1), oby + y - 1 - (parentY - 1), sub(bgCol, math.max(1 - x + 1, 1), math.max(self.width - x + 1,1)))
                else
                    drawHelper.setBG(math.max(x + (obx - 1), obx), oby + y - 1, sub(bgCol, math.max(1 - x + 1, 1), math.max(self.width - x + 1,1)))
                end
            end
        end;

        setFG = function(self, x, y, fgCol)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            if (y >= 1) and (y <= self.height) then
                if (self.parent ~= nil) then
                    local parentX, parentY = self.parent:getAnchorPosition()
                    self.parent:setFG(math.max(x + (obx - 1), obx) - (parentX - 1), oby + y - 1 - (parentY - 1), sub(fgCol, math.max(1 - x + 1, 1), math.max(self.width - x + 1,1)))
                else
                    drawHelper.setFG(math.max(x + (obx - 1), obx), oby + y - 1, sub(fgCol, math.max(1 - x + 1, 1), math.max(self.width - x + 1,1)))
                end
            end
        end;

        writeText = function(self, x, y, text, bgCol, fgCol)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            if (y >= 1) and (y <= self.height) then
                if (self.parent ~= nil) then
                    local parentX, parentY = self.parent:getAnchorPosition()
                    self.parent:writeText(math.max(x + (obx - 1), obx) - (parentX - 1), oby + y - 1 - (parentY - 1), sub(text, math.max(1 - x + 1, 1), self.width - x + 1), bgCol, fgCol)
                else
                    drawHelper.writeText(math.max(x + (obx - 1), obx), oby + y - 1, sub(text, math.max(1 - x + 1, 1), math.max(self.width - x + 1,1)), bgCol, fgCol)
                end
            end
        end;

        drawBackgroundBox = function(self, x, y, width, height, bgCol)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            height = (y < 1 and (height + y > self.height and self.height or height + y - 1) or (height + y > self.height and self.height - y + 1 or height))
            width = (x < 1 and (width + x > self.width and self.width or width + x - 1) or (width + x > self.width and self.width - x + 1 or width))
            if (self.parent ~= nil) then
                local parentX, parentY = self.parent:getAnchorPosition()
                self.parent:drawBackgroundBox(math.max(x + (obx - 1), obx) - (parentX - 1), math.max(y + (oby - 1), oby) - (parentY - 1), width, height, bgCol)
            else
                drawHelper.drawBackgroundBox(math.max(x + (obx - 1), obx), math.max(y + (oby - 1), oby), width, height, bgCol)
            end
        end;

        drawTextBox = function(self, x, y, width, height, symbol)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            height = (y < 1 and (height + y > self.height and self.height or height + y - 1) or (height + y > self.height and self.height - y + 1 or height))
            width = (x < 1 and (width + x > self.width and self.width or width + x - 1) or (width + x > self.width and self.width - x + 1 or width))
            if (self.parent ~= nil) then
                local parentX, parentY = self.parent:getAnchorPosition()
                self.parent:drawTextBox(math.max(x + (obx - 1), obx) - (parentX - 1), math.max(y + (oby - 1), oby) - (parentY - 1), width, height, symbol:sub(1, 1))
            else
                drawHelper.drawTextBox(math.max(x + (obx - 1), obx), math.max(y + (oby - 1), oby), width, height, symbol:sub(1, 1))
            end
        end;

        drawForegroundBox = function(self, x, y, width, height, fgCol)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            height = (y < 1 and (height + y > self.height and self.height or height + y - 1) or (height + y > self.height and self.height - y + 1 or height))
            width = (x < 1 and (width + x > self.width and self.width or width + x - 1) or (width + x > self.width and self.width - x + 1 or width))
            if (self.parent ~= nil) then
                local parentX, parentY = self.parent:getAnchorPosition()
                self.parent:drawForegroundBox(math.max(x + (obx - 1), obx) - (parentX - 1), math.max(y + (oby - 1), oby) - (parentY - 1), width, height, fgCol)
            else
                drawHelper.drawForegroundBox(math.max(x + (obx - 1), obx), math.max(y + (oby - 1), oby), width, height, fgCol)
            end
        end;

        draw = function(self)
            if(isMonitor)and not(monitorAttached)then return false end;
            if (self:getVisualChanged()) then
                if (base.draw(self)) then
                    local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                    local anchx, anchy = self:getAnchorPosition()
                    if (self.parent ~= nil) then
                        if(self.bgColor~=false)then
                            self.parent:drawBackgroundBox(anchx, anchy, self.width, self.height, self.bgColor)
                            self.parent:drawTextBox(anchx, anchy, self.width, self.height, " ")
                        end
                        if(self.bgColor~=false)then self.parent:drawForegroundBox(anchx, anchy, self.width, self.height, self.fgColor) end
                    else
                        if(self.bgColor~=false)then
                            drawHelper.drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                            drawHelper.drawTextBox(obx, oby, self.width, self.height, " ")
                        end
                        if(self.fgColor~=false)then drawHelper.drawForegroundBox(obx, oby, self.width, self.height, self.fgColor) end
                    end
                    termObject.setCursorBlink(false)
                    if (self.barActive) then
                        if (self.parent ~= nil) then
                            self.parent:writeText(anchx, anchy, getTextHorizontalAlign(self.barText, self.width, self.barTextAlign), self.barBackground, self.barTextcolor)
                        else
                            drawHelper.writeText(obx, oby, getTextHorizontalAlign(self.barText, self.width, self.barTextAlign), self.barBackground, self.barTextcolor)
                        end
                        if(self:getBorder("left"))then
                            if (self.parent ~= nil) then
                                self.parent:drawBackgroundBox(anchx-1, anchy, 1, 1, self.barBackground)
                                if(self.bgColor~=false)then
                                    self.parent:drawBackgroundBox(anchx-1, anchy+1, 1, self.height-1, self.bgColor)
                                end
                            end
                        end
                        if(self:getBorder("top"))then
                            if (self.parent ~= nil) then
                                self.parent:drawBackgroundBox(anchx-1, anchy-1, self.width+1, 1, self.barBackground)
                            end
                        end
                    end

                    for _, index in rpairs(objZIndex) do
                        if (objects[index] ~= nil) then
                            for _, value in pairs(objects[index]) do
                                if (value.draw ~= nil) then
                                    value:draw()
                                end
                            end
                        end
                    end

                    if (cursorBlink) then
                        termObject.setTextColor(cursorColor)
                        termObject.setCursorPos(xCursor, yCursor)
                        if (self.parent ~= nil) then
                            termObject.setCursorBlink(self:isFocused())
                        else
                            termObject.setCursorBlink(cursorBlink)
                        end
                    end
                    self:setVisualChanged(false)
                end
            end
        end;

        drawUpdate = function(self)
            if(isMonitor)and not(monitorAttached)then return false end;
            drawHelper.update()
        end;

        addObject = function(self, obj)
            return addObject(obj)
        end;

        removeObject = function(self, obj)
            return removeObject(obj)
        end;

        getObject = function(self, obj)
            return getObject(obj)
        end;

        addButton = function(self, name)
            local obj = Button(name)
            obj.name = name
            return addObject(obj)
        end;

        addLabel = function(self, name)
            local obj = Label(name)
            obj.bgColor = self.bgColor
            obj.fgColor = self.fgColor
            return addObject(obj)
        end;

        addCheckbox = function(self, name)
            local obj = Checkbox(name)
            return addObject(obj)
        end;

        addInput = function(self, name)
            local obj = Input(name)
            return addObject(obj)
        end;

        addProgram = function(self, name)
            local obj = Program(name)
            return addObject(obj)
        end;

        addTextfield = function(self, name)
            local obj = Textfield(name)
            return addObject(obj)
        end;

        addList = function(self, name)
            local obj = List(name)
            obj.name = nam
            return addObject(obj)
        end;

        addDropdown = function(self, name)
            local obj = Dropdown(name)
            return addObject(obj)
        end;

        addRadio = function(self, name)
            local obj = Radio(name)
            return addObject(obj)
        end;

        addTimer = function(self, name)
            local obj = Timer(name)
            return addObject(obj)
        end;

        addAnimation = function(self, name)
            local obj = Animation(name)
            return addObject(obj)
        end;

        addSlider = function(self, name)
            local obj = Slider(name)
            return addObject(obj)
        end;

        addScrollbar = function(self, name)
            local obj = Scrollbar(name)
            return addObject(obj)
        end;

        addMenubar = function(self, name)
            local obj = Menubar(name)
            return addObject(obj)
        end;

        addThread = function(self, name)
            local obj = Thread(name)
            return addObject(obj)
        end;

        addPane = function(self, name)
            local obj = Pane(name)
            return addObject(obj)
        end;

        addImage = function(self, name)
            local obj = Image(name)
            return addObject(obj)
        end;

        addProgressbar = function(self, name)
            local obj = Progressbar(name)
            return addObject(obj)
        end;

        addSwitch = function(self, name)
            local obj = Switch(name)
            return addObject(obj)
        end;

        addFrame = function(self, name)
            local obj = Frame(name, self)
            return addObject(obj)
        end;
    }
    setmetatable(object, base)
    return object
end
local function drawFrames()
    mainFrame:draw()
    mainFrame:drawUpdate()
    for _,v in pairs(monFrames)do
        v:draw()
        v:drawUpdate()
    end
end

local updaterActive = false
local function basaltUpdateEvent(event, p1, p2, p3, p4)
    if(eventSystem:sendEvent("basaltEventCycle", event, p1, p2, p3, p4)==false)then return end
    if(mainFrame~=nil)then
        if (event == "mouse_click") then
            mainFrame:mouseHandler(event, p1, p2, p3, p4)
            activeFrame = mainFrame
        elseif (event == "mouse_drag") then
            mainFrame:mouseHandler(event, p1, p2, p3, p4)
            activeFrame = mainFrame
        elseif (event == "mouse_up") then
            mainFrame:mouseHandler(event, p1, p2, p3, p4)
            activeFrame = mainFrame
        elseif (event == "mouse_scroll") then
            mainFrame:mouseHandler(event, p1, p2, p3, p4)
            activeFrame = mainFrame
        elseif (event == "monitor_touch") then
            if(monFrames[p1]~=nil)then
                monFrames[p1]:mouseHandler(event, p1, p2, p3, p4)
                activeFrame = monFrames[p1]
            end
        end
    end

    if(event == "key") or (event == "char") then
        activeFrame:keyHandler(event, p1)
        activeFrame:backgroundKeyHandler(event, p1)
    end

    if(event == "key")then
        keyActive[p1] = true
    end

    if(event == "key_up")then
        keyActive[p1] = false
    end

    for _, v in pairs(frames) do
        v:eventHandler(event, p1, p2, p3, p4)
    end
    drawFrames()
end

function basalt.autoUpdate(isActive)
    updaterActive = isActive
    if(isActive==nil)then updaterActive = true end
    drawFrames()
    while updaterActive do
        local event, p1, p2, p3, p4 = os.pullEventRaw() -- change to raw later
        basaltUpdateEvent(event, p1, p2, p3, p4)
    end
end

function basalt.update(event, p1, p2, p3, p4)
    if (event ~= nil) then
        basaltUpdateEvent(event, p1, p2, p3, p4)
    end
end

function basalt.stop()
    updaterActive = false
end

function basalt.isKeyDown(key)
    if(keyActive[key]==nil)then return false end
    return keyActive[key];
end

function basalt.getFrame(name)
    for _, value in pairs(frames) do
        if (value.name == name) then
            return value
        end
    end
end

function basalt.getActiveFrame()
    return activeFrame
end

function basalt.setActiveFrame(frame)
    if (frame:getType() == "Frame") then
        activeFrame = frame
        return true
    end
    return false
end

function basalt.onEvent(...)
    for _,v in pairs(table.pack(...))do
        if(type(v)=="function")then
            eventSystem:registerEvent("basaltEventCycle", v)
        end
    end
end

function basalt.createFrame(name)
    for _, v in pairs(frames) do
        if (v.name == name) then
            return nil
        end
    end
    local newFrame = Frame(name)
    table.insert(frames, newFrame)
    return newFrame
end

function basalt.removeFrame(name)
    frames[name] = nil
end


if (basalt.debugger) then
    basalt.debugFrame = basalt.createFrame("basaltDebuggingFrame"):showBar():setBackground(colors.lightGray):setBar("Debug", colors.black, colors.gray)
    basalt.debugList = basalt.debugFrame:addList("debugList"):setSize(basalt.debugFrame.width - 2, basalt.debugFrame.height - 3):setPosition(2, 3):setScrollable(true):show()
    basalt.debugFrame:addButton("back"):setAnchor("topRight"):setSize(1, 1):setText("\22"):onClick(function() basalt.oldFrame:show() end):setBackground(colors.red):show()
    basalt.debugLabel = basalt.debugFrame:addLabel("debugLabel"):onClick(function() basalt.oldFrame = mainFrame basalt.debugFrame:show() end):setBackground(colors.black):setForeground(colors.white):setAnchor("bottomLeft"):ignoreOffset():setZIndex(20):show()
end

if (basalt.debugger) then
    function basalt.debug(...)
        local args = { ... }
        if (mainFrame.name ~= "basaltDebuggingFrame") then
            if (mainFrame ~= basalt.debugFrame) then
                basalt.debugLabel:setParent(mainFrame)
            end
        end
        local str = ""
        for key, value in pairs(args) do
            str = str .. tostring(value) .. (#args ~= key and ", " or "")
        end
        basalt.debugLabel:setText("[Debug] " .. str)
        basalt.debugList:addItem(str)
        if (basalt.debugList:getItemCount() > 50) then
            basalt.debugList:removeItem(1)
        end
        basalt.debugList:setValue(basalt.debugList:getItem(basalt.debugList:getItemCount()))
        if(basalt.debugList.getItemCount() > basalt.debugList:getHeight())then
            basalt.debugList:setIndexOffset(basalt.debugList:getItemCount() - basalt.debugList:getHeight())
        end
        basalt.debugLabel:show()
    end
end

return basalt
