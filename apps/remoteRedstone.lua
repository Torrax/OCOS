-- Libraries
local computer = require("computer")
local sides = require("sides")
local shell = require("shell")
local component = require("component")
local GUI = require("gui")

local nPower = 50
local sPower = 50
local ePower = 50
local wPower = 50
local tPower = 50
local bPower = 50

-- Create new workspace
local workspace = GUI.application()

--Red Outter Panel
workspace:addChild(GUI.panel(0, 0, 161, 101, 0x880000))
--Grey Inlay
workspace:addChild(GUI.panel(5, 8, 151, 40, 0x262626))
--Label Boxes
workspace:addChild(GUI.panel(60, 12, 15, 3, 0xE1E1E1))
workspace:addChild(GUI.label(60, 12, 15, 3, 0x4B4B4B, "North")):setAlignment(GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_CENTER)
workspace:addChild(GUI.panel(110, 12, 15, 3, 0xE1E1E1))
workspace:addChild(GUI.label(110, 12, 15, 3, 0x4B4B4B, "South")):setAlignment(GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_CENTER)
workspace:addChild(GUI.panel(60, 22, 15, 3, 0xE1E1E1))
workspace:addChild(GUI.label(60, 22, 15, 3, 0x4B4B4B, "East")):setAlignment(GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_CENTER)
workspace:addChild(GUI.panel(110, 22, 15, 3, 0xE1E1E1))
workspace:addChild(GUI.label(110, 22, 15, 3, 0x4B4B4B, "West")):setAlignment(GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_CENTER)
workspace:addChild(GUI.panel(60, 32, 15, 3, 0xE1E1E1))
workspace:addChild(GUI.label(60, 32, 15, 3, 0x4B4B4B, "Top")):setAlignment(GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_CENTER)
workspace:addChild(GUI.panel(110, 32, 15, 3, 0xE1E1E1))
workspace:addChild(GUI.label(110, 32, 15, 3, 0x4B4B4B, "Bottom")):setAlignment(GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_CENTER)

-- Quit Button
local notAnimatedButton = workspace:addChild(GUI.button(132, 2, 25, 3, 0xAAAAAA, 0x4B4B4B, 0xE1E1E1, 0x4B4B4B, "Exit"))
notAnimatedButton.animated = false
notAnimatedButton.onTouch = function()
	shell.execute("/home/ui.lua")
        os.close()
end

-- Controller List
local verticalList = workspace:addChild(GUI.list(10, 13, 25, 30, 3, 0, 0xE1E1E1, 0x4B4B4B, 0xD2D2D2, 0x4B4B4B, 0x3366CC, 0xFFFFFF, false))
verticalList:addItem("Controller 1")
verticalList:addItem("Controller 2").onTouch = function()
	GUI.alert("Controller Selected " .. verticalList.selectedItem) --FUNCTION
end
verticalList:addItem("Controller 3")
verticalList:addItem("Controller 4")

-- Controller Buttons
workspace:addChild(GUI.roundedButton(50, 15, 15, 3, 0x22DA00, 0x4B4B4B, 0x148700, 0x4B4B4B, "ON")).onTouch = function() -- North ON
	component.redstone.setOutput(sides.north, nPower) computer.beep(600,0.5)
end
workspace:addChild(GUI.roundedButton(70, 15, 15, 3, 0xE30000, 0x4B4B4B, 0x880000, 0x4B4B4B, "OFF")).onTouch = function() -- North OFF
	component.redstone.setOutput(sides.north, 0) computer.beep(100,0.8)
end
local slider = workspace:addChild(GUI.slider(51, 19, 32, 0x66DB80, 0x0, 0xFFFFFF, 0xAAAAAA, 0, 50, 50, true, "Signal Strength: ", ""))  -- North Signal
slider.roundValues = true
slider.onValueChanged = function()
	nPower = slider.value
end

workspace:addChild(GUI.roundedButton(100, 15, 15, 3, 0x22DA00, 0x4B4B4B, 0x148700, 0x4B4B4B, "ON")).onTouch = function() -- South ON
	component.redstone.setOutput(sides.south, sPower) computer.beep(600,0.5)
end
workspace:addChild(GUI.roundedButton(120, 15, 15, 3, 0xE30000, 0x4B4B4B, 0x880000, 0x4B4B4B, "OFF")).onTouch = function() -- South OFF
	component.redstone.setOutput(sides.south, 0) computer.beep(100,0.8)
end
local slider = workspace:addChild(GUI.slider(101, 19, 32, 0x66DB80, 0x0, 0xFFFFFF, 0xAAAAAA, 0, 50, 50, true, "Signal Strength: ", "")) -- South Signal
slider.roundValues = true
slider.onValueChanged = function()
	sPower = slider.value
end

workspace:addChild(GUI.roundedButton(50, 25, 15, 3, 0x22DA00, 0x4B4B4B, 0x148700, 0x4B4B4B, "ON")).onTouch = function() -- East ON
	component.redstone.setOutput(sides.east, ePower) computer.beep(600,0.5)
end
workspace:addChild(GUI.roundedButton(70, 25, 15, 3, 0xE30000, 0x4B4B4B, 0x880000, 0x4B4B4B, "OFF")).onTouch = function() -- East OFF
	component.redstone.setOutput(sides.east, 0) computer.beep(100,0.8)
end
local slider = workspace:addChild(GUI.slider(51, 29, 32, 0x66DB80, 0x0, 0xFFFFFF, 0xAAAAAA, 0, 50, 50, true, "Signal Strength: ", "")) -- East Signal
slider.roundValues = true
slider.onValueChanged = function()
	ePower = slider.value
end

workspace:addChild(GUI.roundedButton(100, 25, 15, 3, 0x22DA00, 0x4B4B4B, 0x148700, 0x4B4B4B, "ON")).onTouch = function() -- West ON
	component.redstone.setOutput(sides.west, wPower) computer.beep(600,0.5)
end
workspace:addChild(GUI.roundedButton(120, 25, 15, 3, 0xE30000, 0x4B4B4B, 0x880000, 0x4B4B4B, "OFF")).onTouch = function() -- West OFF
	component.redstone.setOutput(sides.west, 0) computer.beep(100,0.8)
end
local slider = workspace:addChild(GUI.slider(101, 29, 32, 0x66DB80, 0x0, 0xFFFFFF, 0xAAAAAA, 0, 50, 50, true, "Signal Strength: ", "")) -- West Signal
slider.roundValues = true
slider.onValueChanged = function()
	wPower = slider.value
end

workspace:addChild(GUI.roundedButton(50, 35, 15, 3, 0x22DA00, 0x4B4B4B, 0x148700, 0x4B4B4B, "ON")).onTouch = function() -- Top ON
	component.redstone.setOutput(sides.top, tPower) computer.beep(600,0.5)
end
workspace:addChild(GUI.roundedButton(70, 35, 15, 3, 0xE30000, 0x4B4B4B, 0x880000, 0x4B4B4B, "OFF")).onTouch = function() -- Top OFF
	component.redstone.setOutput(sides.top, 0) computer.beep(100,0.8)
end
local slider = workspace:addChild(GUI.slider(51, 39, 32, 0x66DB80, 0x0, 0xFFFFFF, 0xAAAAAA, 0, 50, 50, true, "Signal Strength: ", "")) -- Top Signal
slider.roundValues = true
slider.onValueChanged = function()
	tPower = slider.value
end

workspace:addChild(GUI.roundedButton(100, 35, 15, 3, 0x22DA00, 0x4B4B4B, 0x148700, 0x4B4B4B, "ON")).onTouch = function() -- Bottom ON
	component.redstone.setOutput(sides.bottom, bPower) computer.beep(600,0.5)
end
workspace:addChild(GUI.roundedButton(120, 35, 15, 3, 0xE30000, 0x4B4B4B, 0x880000, 0x4B4B4B, "OFF")).onTouch = function() -- Bottom Off
	component.redstone.setOutput(sides.bottom, 0) computer.beep(100,0.8)
end
local slider = workspace:addChild(GUI.slider(101, 39, 32, 0x66DB80, 0x0, 0xFFFFFF, 0xAAAAAA, 0, 50, 50, true, "Signal Strength: ", "")) -- Bottom Signal
slider.roundValues = true
slider.onValueChanged = function()
	bPower = slider.value
end

-- All Control
local notAnimatedButton = workspace:addChild(GUI.button(63, 43, 25, 4, 0x22DA00, 0x4B4B4B, 0x148700, 0x4B4B4B, "ALL ON"))
notAnimatedButton.animated = false
notAnimatedButton.onTouch = function()
	component.redstone.setOutput(sides.north, nPower)
	component.redstone.setOutput(sides.south, sPower)
	component.redstone.setOutput(sides.east, ePower)
	component.redstone.setOutput(sides.west, wPower)
	component.redstone.setOutput(sides.top, tPower)
	component.redstone.setOutput(sides.bottom, bPower) computer.beep(750,0.8)
end

local notAnimatedButton = workspace:addChild(GUI.button(93, 43, 25, 4, 0xE30000, 0x4B4B4B, 0x880000, 0x4B4B4B, "ALL OFF"))
notAnimatedButton.animated = false
notAnimatedButton.onTouch = function()
	component.redstone.setOutput(sides.north, 0)
	component.redstone.setOutput(sides.south, 0)
	component.redstone.setOutput(sides.east, 0)
	component.redstone.setOutput(sides.west, 0)
	component.redstone.setOutput(sides.top, 0)
	component.redstone.setOutput(sides.bottom, 0) computer.beep(250,1.2)
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
