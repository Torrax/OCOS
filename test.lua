-- Libraries
local shell = require("shell")
local component = require("component")
local GUI = require("gui")

-- Create new workspace
local workspace = GUI.application()

-- Add panel that fits workspace
workspace:addChild(GUI.panel(0, 0, 161, 101, 0x880000))
-- Add smaller red panel
workspace:addChild(GUI.panel(5, 8, 151, 40, 0x262626))

-- Create vertically oriented list
local verticalList = workspace:addChild(GUI.list(10, 13, 25, 30, 3, 0, 0xE1E1E1, 0x4B4B4B, 0xD2D2D2, 0x4B4B4B, 0x3366CC, 0xFFFFFF, false))
verticalList:addItem("Controller 1")
verticalList:addItem("Controller 2").onTouch = function()
	GUI.alert("Controller Selected " .. verticalList.selectedItem)
	--shell.execute("/home/ui.lua")
        os.close()
end
verticalList:addItem("Controller 3")
verticalList:addItem("Controller 4")

-- Buttons
workspace:addChild(GUI.button(50, 15, 15, 3, 0xFFFFFF, 0x555555, 0x22DA00, 0xFFFFFF, "ON")).onTouch = function()
	GUI.alert("Front Side ON")
end
workspace:addChild(GUI.button(70, 15, 15, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "OFF")).onTouch = function()
	GUI.alert("Front Side OFF")
end

--------------------------------------------------------------------------------

-- Get Redstone Devices
function getRedstoneIO()
  local countRedstoneIO = 0
	
	local RedstoneIO = component.list("redstone")
	
	local redstoneID = {}	
	for address, name in pairs(RedstoneIO) do
		countRedstoneIO =  countRedstoneIO + 1
		if countRedstoneIO > 1 then
			redstoneID[address] = "Redstone Controller" .. " " .. countRedstoneIO
		else
			redstoneID[address] ="Redstone Controller"
		end	
	end
  return cellsID
end

-- Start Script
workspace:draw()
workspace:start()

local controllerID = getRedstoneIO()

while true do
  local _,_,x,y = event.pull( 1, "touch" )
  local count = 0 
  for address, name in pairs(controllerID) do
    
	    local cell = component.proxy( address )
	    count = count + 1
	    local x1 = count * 3
	    --progressBar( name, t , cell.getEnergyStored(), cell.getMaxEnergyStored() , 0x00bb00, true, "RF" )
      
	end
  os.sleep(0.25)
end
