-- Import libraries
local GUI = require("GUI")
local buffer = require("doubleBuffering")
local shell = require("shell")
local event = require("event")
--------------------------------------------------------------------------------

-- Create new application
local application = GUI.application()

-- Add panel that fits application
application:addChild(GUI.panel(1, 1, application.width, application.height, 0x999999))

-- Add smaller red panel

application:addChild(GUI.panel(0, 0, 165, 5, 0x666666))
application:addChild(GUI.label(0, 0, 165, 5, 0x999999, "TorUI")):setAlignment(GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_CENTER)
application:addChild(GUI.panel(17, 11, 35, 12, 0x666666))
application:addChild(GUI.label(17, 11, 35, 12, 0x999999, "Inventory")):setAlignment(GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_CENTER)
application:addChild(GUI.panel(62, 11, 35, 12, 0x666666))
application:addChild(GUI.label(62, 11, 35, 12, 0x999999, "iFace")):setAlignment(GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_CENTER)
application:addChild(GUI.panel(107, 11, 35, 12, 0x666666))
application:addChild(GUI.label(107, 11, 35, 12, 0x999999, "Drone Control")):setAlignment(GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_CENTER)
application:addChild(GUI.panel(17, 28, 35, 12, 0x666666))
application:addChild(GUI.label(17, 28, 35, 12, 0x999999, "Nuclear Control")):setAlignment(GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_CENTER)
application:addChild(GUI.panel(62, 28, 35, 12, 0x666666))
application:addChild(GUI.label(62, 28, 35, 12, 0x999999, "Security Control")):setAlignment(GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_CENTER)
application:addChild(GUI.panel(107, 28, 35, 12, 0x666666))
application:addChild(GUI.label(107, 28, 35, 12, 0x999999, "Redstone Control")):setAlignment(GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_CENTER)
application:addChild(GUI.panel(145, 45, 15, 5, 0xE10000))
application:addChild(GUI.label(145, 45, 15, 5, 0x999999, "System")):setAlignment(GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_CENTER)

--------------------------------------------------------------------------------

-- Draw application content once on screen when program starts
application:draw(true)

-- Touch/Click Checking
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
