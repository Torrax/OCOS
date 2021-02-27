-- Import libraries
local component = require("component")
local gui = require("gui")
local buffer = require("doubleBuffering")
local shell = require("shell")
local event = require("event")
local image = require("image")
--------------------------------------------------------------------------------
local function drawStatic()
    -- Set Resolution 160 x 50
    buffer.setResolution(160, 50)
    
    -- Draw Background
    buffer.drawImage(1 , 1, image.load("/home/images/torUI.pic"))
    
    -- Clock
    buffer.drawSemiPixelRectangle( 9, 2, 17, 8, 0x000000)
    buffer.drawSemiPixelRectangle( 10, 3, 15, 6, 0x999999)
    buffer.drawText(13, 3, 0x000000, (os.date("%H:%M:%S", os.time())));
    
    -- Battery
    buffer.drawSemiPixelRectangle( 141, 2, 12, 8, 0x000000)
    buffer.drawSemiPixelRectangle( 142, 3, 11, 6, 0x999999)
    
    buffer.drawSemiPixelRectangle( 142, 3, 11, 6, 0x22DA00)
    buffer.drawText(145, 3, 0x000000, "99 %");
    
    buffer.drawSemiPixelRectangle( 152, 2, 1, 3, 0x000000)
    buffer.drawSemiPixelRectangle( 152, 7, 1, 3, 0x000000)
    buffer.drawSemiPixelRectangle( 153, 4, 1, 4, 0x000000)
    buffer.drawSemiPixelRectangle( 153, 2, 1, 2, 0x666666)
    buffer.drawSemiPixelRectangle( 153, 8, 1, 2, 0x666666)
    
    -- Draw Application Buttons
    buffer.drawImage(17 , 11, image.load("/home/images/app_Stocker.pic"))   -- Stocker Logo Button
    buffer.drawImage(62 , 11, image.load("/home/images/app_iFace.pic"))   -- iFace Logo Button
    buffer.drawImage(107 , 11, image.load("/home/images/app_securityPanel.pic"))   -- Drone Control Logo Button
    buffer.drawImage(17 , 28, image.load("/home/images/app_nuclearController.pic"))   -- Nuclear Control Logo Button
    buffer.drawImage(62 , 28, image.load("/home/images/app_droneControl.pic"))   -- Security Panel Logo Button
    buffer.drawImage(107 , 28, image.load("/home/images/app_remoteRedstone.pic"))   -- Remote Redstone Logo Button

    buffer.drawSemiPixelRectangle( 144, 89, 16, 10, 0x000000)
    buffer.drawSemiPixelRectangle( 145, 90, 14, 8, 0x474747)
    buffer.drawText(149, 47, 0x000000, "System");
end

local function drawDynamic()
end

buffer.flush()
drawStatic()
drawDynamic()

buffer.drawChanges()
--------------------------------------------------------------------------------

-- Touch/Click Checking
while true do
    local _, _, x, y = event.pull("touch")

    if x and y then
        buffer.clear()
        buffer.drawChanges()
        component.gpu.setForeground(0xFFFFFF)
    -- Battery Button
    if x >= 142 and x <= 153 and y >= 2 and y <= 4 then
        shell.execute("/usr/apps/battery.lua")
        os.exit()
    end
    
    -- Inventory Button
    if x >= 17 and x <= 51 and y >= 11 and y <= 22 then
        shell.execute("/usr/apps/stocker.lua")
        os.exit()
    end
    
    -- iFace Button
    if x >= 62 and x <= 96 and y >= 11 and y <= 22 then
        --shell.execute("/usr/apps/iFace.lua")
        os.exit()
    end
    
    -- Drone Control Button
    if x >= 107 and x <= 141 and y >= 11 and y <= 22 then
        --shell.execute("/usr/apps/droneControl.lua")
        os.exit()
    end
    
    -- Nuclear Control Button
    if x >= 17 and x <= 51 and y >= 28 and y <= 39 then
        shell.execute("/usr/apps/nuclearControl.lua")
        os.exit()
    end
    
    -- Security Control Button
    if x >= 62 and x <= 96 and y >= 28 and y <= 39 then
        --shell.execute("/usr/apps/securityPanel.lua")
        os.exit()
    end
    
    -- Redstone Control Button
    if x >= 107 and x <= 141 and y >= 28 and y <= 39 then
        shell.execute("/usr/apps/remoteRedstone.lua")
        os.exit()
    end
    
    -- System Button
    if x >= 145 and x <= 159 and y >= 45 and y <= 49 then
        os.exit() 
    end
end
end
