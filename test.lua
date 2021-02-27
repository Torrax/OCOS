-- Libraries
local shell = require("shell")
local component = require("component")

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
gpu.set( 67, 1, "Remote Redstone" )

local controllerID = getRedstoneIO()

while true do
  local _,_,x,y = event.pull( 1, "touch" )
  local count = 0 
  if x and y then goto quit end -- QUIT on Click
  for address, name in pairs(controllerID) do
    
	    local cell = component.proxy( address )
	    count = count + 1
	    local x1 = count * 3
	    --progressBar( name, t , cell.getEnergyStored(), cell.getMaxEnergyStored() , 0x00bb00, true, "RF" )
      
	end
  os.sleep(0.25)
end
 
 
::quit::
shell.execute("/home/ui.lua")
os.close()
