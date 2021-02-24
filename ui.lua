-- Import libraries
local GUI = require("GUI")
local buffer = require("doubleBuffering")
local shell = require("shell")
local event = require("event")
--------------------------------------------------------------------------------

-- Create new application
local application = GUI.application()

-- Create and add template object to application
local taskbar = application:addChild(GUI.object(0, 0, 165, 5))

local invManager = application:addChild(GUI.object(17, 11, 35, 12))
local iFace = application:addChild(GUI.object(62, 11, 35, 12))
local drone = application:addChild(GUI.object(107, 11, 35, 12))
local nuclear = application:addChild(GUI.object(17, 28, 35, 12))
local security = application:addChild(GUI.object(62, 28, 35, 12))
local redstone = application:addChild(GUI.object(107, 28, 35, 12))
local exit = application:addChild(GUI.object(145, 45, 15, 5))

--Clear Screen and Set Background Colour
buffer.clear(0x999999)

-- Draw Taskbar
taskbar.draw = function(object)
    buffer.drawRectangle(object.x, object.y, object.width, object.height, 0x666666, 0x0, " ")
end

-- Draw Inventory Button and Text
invManager.draw = function(object)
    buffer.drawRectangle(object.x, object.y, object.width, object.height, 0x666666, 0x0, " ")
    buffer.drawText(object.x + 14, object.y + 6, 0x999999, "Inventory")
end

-- Draw iFace Button and Text
iFace.draw = function(object)
    buffer.drawRectangle(object.x, object.y, object.width, object.height, 0x666666, 0x0, " ")
    buffer.drawText(object.x + 16, object.y + 6, 0x999999, "iFace")
end

-- Draw Drone Control Button and Text
drone.draw = function(object)
    buffer.drawRectangle(object.x, object.y, object.width, object.height, 0x666666, 0x0, " ")
    buffer.drawText(object.x + 12, object.y + 6, 0x999999, "Drone Control")
end

-- Draw Nuclear Control Button and Text
nuclear.draw = function(object)
    buffer.drawRectangle(object.x, object.y, object.width, object.height, 0x666666, 0x0, " ")
    buffer.drawText(object.x + 10, object.y + 6, 0x999999, "Nuclear Control")
end

-- Draw Security Control Button and Text
security.draw = function(object)
    buffer.drawRectangle(object.x, object.y, object.width, object.height, 0x666666, 0x0, " ")
    buffer.drawText(object.x + 10, object.y + 6, 0x999999, "Security Control")
end

-- Draw Redstone Control Button and Text
redstone.draw = function(object)
    buffer.drawRectangle(object.x, object.y, object.width, object.height, 0x666666, 0x0, " ")
    buffer.drawText(object.x + 10, object.y + 6, 0x999999, "Redstone Control")
end

-- Draw System Button and Text
exit.draw = function(object)
    buffer.drawRectangle(object.x, object.y, object.width, object.height, 0xE10000, 0x0, " ")
    buffer.drawText(object.x + 5, object.y + 2, 0x999999, "System")
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
