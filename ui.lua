-- Import libraries
local GUI = require("GUI")
local buffer = require("doubleBuffering")
local shell = require("shell")
local event = require("event")
--------------------------------------------------------------------------------

-- Create new application
local application = GUI.application()

-- Create and add template object to application
local invManager = application:addChild(GUI.object(5, 3, 35, 10))
local exit = application:addChild(GUI.object(145, 45, 15, 5))

--Clear Screen and Set Background Colour
buffer.clear(0x999999)

-- Draw Inventory Button and Text
invManager.draw = function(object)
    buffer.drawRectangle(object.x, object.y, object.width, object.height, 0x666666, 0x0, " ")
    buffer.drawText(object.x + 14, object.y + 5, 0x999999, "Inventory")
end

-- Draw Exit Button and Text
exit.draw = function(object)
    buffer.drawRectangle(object.x, object.y, object.width, object.height, 0xE10000, 0x0, " ")
    buffer.drawText(object.x + 6, object.y + 2, 0x999999, "Exit")
end

--------------------------------------------------------------------------------

-- Draw application content once on screen when program starts
application:draw(true)

while true do
    local _, _, x, y = event.pull("touch")

    -- Inventory Button
    if x >= 5 and x <= 40 and y >= 5 and y <= 15 then
        shell.execute("/usr/apps/invManager.lua")
        os.exit()
    end
    
    -- System Button
    if x >= 145 and x <= 160 and y >= 45 and y <= 50 then
        os.exit() 
    end

end
