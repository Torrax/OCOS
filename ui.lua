-- Import libraries
local GUI = require("GUI")
local buffer = require("doubleBuffering")
local shell = require("shell")
local event = require("event")
local image = require("image")
--------------------------------------------------------------------------------

buffer.flush()

buffer.setResolution(160,50)

-- Create new application
local application = GUI.application()


-- Draw UI Background
buffer.drawImage(1 , 1, image.load("/home/images/torUI.pic"))

-- Draw Taskbar & Utilities
application:addChild(GUI.panel(9, 2, 14, 3, 0x999999))
application:addChild(GUI.label(12, 1, 165, 5, 0x000000, (os.date("%H:%M:%S", os.time())))):setAlignment(GUI.ALIGNMENT_HORIZONTAL_LEFT, GUI.ALIGNMENT_VERTICAL_CENTER)

-- Empty Battery
application:addChild(GUI.panel(142, 2, 11, 3, 0x000000))  -- Empty
application:addChild(GUI.panel(142, 2, 11, 3, 0x22DA00))  --Charged
application:addChild(GUI.panel(152, 2, 1, 1, 0x666666))   --Blocker 1
application:addChild(GUI.panel(152, 4, 1, 1, 0x666666))   --Blocker 2
application:addChild(GUI.label(142, 2, 10, 3, 0x000000, "99 %")):setAlignment(GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_CENTER)

-- Draw Application Buttons
application:addChild(GUI.panel(1, 160, 164, 4, 0x000000))
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
buffer.drawChanges()

-- Touch/Click Checking
while true do
    local _, _, x, y = event.pull("touch")

    -- Battery Button
    if x >= 147 and x <= 156 and y >= 2 and y <= 4 then
        --shell.execute("/usr/apps/battery.lua")
        os.exit()
    end
    
    -- Inventory Button
    if x >= 17 and x <= 51 and y >= 11 and y <= 22 then
        shell.execute("/usr/apps/invManager.lua")
        os.exit()
    end
    
    -- iFace Button
    if x >= 62 and x <= 96 and y >= 11 and y <= 22 then
        --shell.execute("/usr/apps/iFace.lua")
        os.exit()
    end
    
    -- Drone Control Button
    if x >= 107 and x <= 141 and y >= 11 and y <= 22 then
        --shell.execute("/usr/apps/droneCtrl.lua")
        os.exit()
    end
    
    -- Nuclear Control Button
    if x >= 17 and x <= 51 and y >= 28 and y <= 39 then
        --shell.execute("/usr/apps/nuclearCtrl.lua")
        os.exit()
    end
    
    -- Security Control Button
    if x >= 62 and x <= 96 and y >= 28 and y <= 39 then
        --shell.execute("/usr/apps/securityCtrl.lua")
        os.exit()
    end
    
    -- Redstone Control Button
    if x >= 107 and x <= 141 and y >= 28 and y <= 39 then
        --shell.execute("/usr/apps/redstoneCtrl.lua")
        os.exit()
    end
    
    -- System Button
    if x >= 145 and x <= 159 and y >= 45 and y <= 49 then
        os.exit() 
    end
end
