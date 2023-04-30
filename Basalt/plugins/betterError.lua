local utils = require("utils")
local wrapText = utils.wrapText

return {
    basalt = function(basalt)
        local frame
        local errorList
        return {
            getBasaltErrorFrame = function()
                return frame
            end,
            basaltError = function(err)
                if(frame==nil)then
                    local mainFrame = basalt.getMainFrame()
                    local w, h = mainFrame:getSize()
                    frame = mainFrame:addMovableFrame("basaltErrorFrame"):setSize(w-20, h-10):setBackground(colors.lightGray):setForeground(colors.white):setZIndex(500)
                    frame:addPane("titleBackground"):setSize(w, 1):setPosition(1, 1):setBackground(colors.black):setForeground(colors.white)
                    frame:setPosition(w/2-frame:getWidth()/2, h/2-frame:getHeight()/2):setBorder(colors.black)
                    frame:addLabel("title"):setText("Basalt Unexpected Error"):setPosition(2, 1):setBackground(colors.black):setForeground(colors.white)
                    errorList = frame:addList("errorList"):setSize(frame:getWidth()-2, frame:getHeight()-6):setPosition(2, 3):setBackground(colors.lightGray):setForeground(colors.white):setSelectionColor(colors.lightGray, colors.gray)
                    frame:addButton("xButton"):setText("x"):setPosition(frame:getWidth(), 1):setSize(1, 1):setBackground(colors.black):setForeground(colors.red):onClick(function() 
                        frame:hide()
                    end)
                    frame:addButton("Clear"):setText("Clear"):setPosition(frame:getWidth()-19, frame:getHeight()-1):setSize(9, 1):setBackground(colors.black):setForeground(colors.white):onClick(function() 
                        errorList:clear()
                    end)
                    frame:addButton("Close"):setText("Close"):setPosition(frame:getWidth()-9, frame:getHeight()-1):setSize(9, 1):setBackground(colors.black):setForeground(colors.white):onClick(function() 
                        basalt.autoUpdate(false)
                        term.clear()
                        term.setCursorPos(1, 1)
                    end)
                end
                frame:show()
                errorList:addItem("--------------------------------------------")
                local err = wrapText(err, frame:getWidth()-2)
                for i=1, #err do
                    errorList:addItem(err[i])
                end
            end
        }
    end
}