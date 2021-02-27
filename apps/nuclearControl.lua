-- APIs
 
local component = require("component")
local term = require("term")
local event = require("event")
local computer = require("computer")
local unicode = require("unicode")
local gpu = component.gpu
 
-- Tables, Variables and Miscellaneous
 
local clear = false
local count = 0
local unit = 1
local option = 0
local state = false
local list = 1
local autoSupplyStatus = true
local sendFuelButton = nil
local repeatSend = 0
local side = nil
local amountFuel = 0
 
function round(number, decimals)
  local power = 10^decimals
  return math.floor(number*power)/power
end
 
function shrink(number)
  if number >= 10^12 then
    return string.format("%.2ft", number / 10^12)
  elseif number >= 10^9 then
    return string.format("%.2fb", number / 10^9)
  elseif number >= 10^6 then
    return string.format("%.2fm", number / 10^6)
  elseif number >= 10^3 then
    return string.format("%.2fk", number / 10^3)
  else
    return tostring(number)
  end
end
 
function errorSequence(text, color, start)
  if start == true then
    term.setCursor((28-#text)/2, 13)
  else
    term.setCursor((136-#text)/2, 36)
  end
  gpu.setForeground(color)
  io.write(text)
  os.sleep(0.01)
end
 
function throwError(text, start)
  gpu.setBackground(0x000000)
  errorSequence(text, 0x150000, start)
  errorSequence(text, 0x2b0000, start)
  errorSequence(text, 0x400000, start)
  errorSequence(text, 0x550000, start)
  errorSequence(text, 0x6a0000, start)
  errorSequence(text, 0x800000, start)
  errorSequence(text, 0x950000, start)
  errorSequence(text, 0xaa0000, start)
  errorSequence(text, 0xbf0000, start)
  errorSequence(text, 0xd40000, start)
  errorSequence(text, 0xea0000, start)
  errorSequence(text, 0xff0000, start)
  os.sleep(0.5)
  errorSequence(text, 0xea0000, start)
  errorSequence(text, 0xd40000, start)
  errorSequence(text, 0xbf0000, start)
  errorSequence(text, 0xaa0000, start)
  errorSequence(text, 0x950000, start)
  errorSequence(text, 0x800000, start)
  errorSequence(text, 0x6a0000, start)
  errorSequence(text, 0x550000, start)
  errorSequence(text, 0x400000, start)
  errorSequence(text, 0x2b0000, start)
  errorSequence(text, 0x150000, start)
  errorSequence(text, 0x000000, start)
  if start == true then
    gpu.setForeground(0xFFFFFF)
  end
end
 
-- Check Buttons
 
function checkButtonA(_, _, x, y)
  if x >= 3 and x <= 52 and y >= 25 and y <= 35 then
    gpu.setBackground(0x00AB66)
    gpu.fill(3, 25, 49, 10, " ")
    drawOnText(0x00AB66)
    if event.pull("drop") then
      gpu.setBackground(0xDC143C)
      gpu.fill(3, 25, 49, 10, " ")
      drawOnText(0xDC143C)
      fission.activate()
      state = true
    end
  end
end
 
function checkButtonB(_, _, x, y)
  if x >= 54 and x <= 103 and y >= 25 and y <= 35 then
    gpu.setBackground(0x00AB66)
    gpu.fill(54, 25, 49, 10, " ")
    drawOffText(0x00AB66)
    if event.pull("drop") then
      gpu.setBackground(0xDC143C)
      gpu.fill(54, 25, 49, 10, " ")
      drawOffText(0xDC143C)
      fission.deactivate()
      state = false
    end
  end
end
 
function checkReboot(_, _, x, y)
  if x >= 103 and x <= 109 and y == 37 then
    gpu.setBackground(0xD3D3D3)
    term.setCursor(103, 37)
    io.write("Reboot")
    if event.pull("drop") then
      gpu.setBackground(0x373737)
      term.setCursor(103, 37)
      io.write("Reboot")
      computer.shutdown(true)
    end
  end
end
 
function checkSupplyFuel(_, _, x, y)
  if x >= 47 and x <= 58 and y == 37 then
    gpu.setBackground(0xD3D3D3)
    term.setCursor(47, 37)
    io.write("Supply Fuel")
    if event.pull("drop") then
      gpu.setBackground(0x373737)
      term.setCursor(47, 37)
      io.write("Supply Fuel")
      if component.isAvailable("me_exportbus") and component.isAvailable("database") and component.isAvailable("nc_fission_reactor") then
        if component.isAvailable("me_controller") or component.isAvailable("me_interface") then
          clear = true
          gpu.setBackground(0x000000)
          screenSupplyFuel()
        else
          throwError("Component(s) unavailable")
        end
      else
        throwError("Component(s) unavailable")
      end
    end
  end
end
 
function checkInductionMatrix(_, _, x, y)
  if x >= 63 and x <= 79 and y == 37 then
    gpu.setBackground(0xD3D3D3)
    term.setCursor(63, 37)
    io.write("Induction Matrix")
    if event.pull("drop") then
      gpu.setBackground(0x373737)
      term.setCursor(63, 37)
      io.write("Induction Matrix")
      if component.isAvailable("induction_matrix") then
        clear = true
        gpu.setBackground(0x000000)
        screenInductionMatrix()
      else
        throwError("Component(s) unavailable")
      end
    end
  end
end
 
function checkWriteShell(_, _, x, y)
--[[
 if x >= 84 and x <= 98 and y == 37 then
  gpu.setBackground(0xD3D3D3)
    term.setCursor(84, 37)
    io.write("Write to Shell")
    if event.pull("drop") then
      gpu.setBackground(0x373737)
      term.setCursor(84, 37)
      io.write("Write to Shell")
      local shell = io.open(".shrc", "w")
      shell:write("/home/fission.lua")
      shell:close()
    end
  end
]]--
end
 
function checkFissionReactor(_, _, x, y)
  if x >= 27 and x <= 42 and y == 37 then
    gpu.setBackground(0xD3D3D3)
    term.setCursor(27, 37)
    io.write("Fission Reactor")
    if event.pull("drop") then
      gpu.setBackground(0x373737)
      term.setCursor(27, 37)
      io.write("Fission Reactor")
      if component.isAvailable("nc_fission_reactor") then
        clear = true
        gpu.setBackground(0x000000)
        screenFission()
      else
        throwError("Component(s) unavailable")
      end
    end
  end
end
 
---- Fission Screen
 
function drawFissionBar()
  fission = component.nc_fission_reactor
  while event.pull(0.1, "interrupted") == nil do
    if clear == true then break end
 
    -- Variables
 
    local energyStored = fission.getEnergyStored()/(fission.getMaxEnergyStored()/100)
    if fission.getEnergyStored() == 0 then
      energyStored = 0
    end
    local maxEnergyStored = fission.getMaxEnergyStored()/(fission.getMaxEnergyStored()/100)
    local remainingEnergyStored = maxEnergyStored - energyStored
    local heatLevel = fission.getHeatLevel()/(fission.getMaxHeatLevel()/100)
    if fission.getHeatLevel() == 0 then
      heatLevel = 0
    end
    local maxHeatLevel = fission.getMaxHeatLevel()/(fission.getMaxHeatLevel()/100)
    local remainingHeatLevel = maxHeatLevel - heatLevel
 
    -- Energy Bar
 
    gpu.setBackground(0x00FF00)
    gpu.fill(3, 3, math.floor(energyStored+0.5), 10, " ")
    gpu.setBackground(0xD3D3D3)
    gpu.fill(3 + math.floor(energyStored+0.5), 3, math.floor(remainingEnergyStored+0.5), 10, " ")
    gpu.setBackground(0x1F1F1F)
    term.setCursor(104, 6)
    io.write("\27[32m", "ENERGY STORED:", "\27[37m")
    term.setCursor(104, 8)
    io.write(round(energyStored, 3), "%      ")
    term.setCursor(104, 10)
    io.write(shrink(fission.getEnergyStored()), " out of ", shrink(fission.getMaxEnergyStored()), "     ")
 
    -- Heat Bar
 
    gpu.setBackground(0xFF0000)
    gpu.fill(3, 14, math.floor(heatLevel+0.5), 10, " ")
    gpu.setBackground(0xD3D3D3)
    gpu.fill(3 + math.floor(heatLevel+0.5), 14, math.floor(remainingHeatLevel+0.5), 10, " ")
    gpu.setBackground(0x1F1F1F)
    term.setCursor(104, 16)
    io.write("\27[31m", "HEAT LEVEL:", "\27[37m")
    term.setCursor(104, 18)
    io.write(round(heatLevel, 3), "%      ")
    term.setCursor(104, 20)
    io.write(shrink(fission.getHeatLevel()), " out of ", shrink(fission.getMaxHeatLevel()), "     ")
 
    -- Draw Info
 
    gpu.setBackground(0x1F1F1F)
    term.setCursor(104, 25)
    io.write("\27[33m", "SIZE: ", "\27[37m", fission.getLengthX(), " x ", fission.getLengthY(), " x ", fission.getLengthZ())
    term.setCursor(125, 25)
    io.write("\27[33m", "CELLS: ", "\27[37m", fission.getNumberOfCells())
    if fission.isProcessing() == true then
      term.setCursor(104, 27)
      io.write("\27[36m", fission.getFissionFuelName(), " FUEL STATS:", "\27[37m")
      term.setCursor(104, 28)
      io.write("Power Generation: ", fission.getFissionFuelPower())
      term.setCursor(104, 29)
      io.write("Heat Generation: ", fission.getFissionFuelHeat())
    elseif fission.isComplete() == true then
      gpu.fill(104, 27, 30, 3, " ")
    end
    term.setCursor(104, 31)
    io.write("\27[36m", "REACTOR STATS:", "\27[37m")
    term.setCursor(104, 32)
    io.write("Power Generation: ", fission.getReactorProcessPower())
    term.setCursor(104, 33)
    io.write("Heat Generation: ", fission.getReactorProcessHeat())
    term.setCursor(104, 34)
    io.write("Cooling Rate: ", fission.getReactorCoolingRate())
 
    -- Automation
 
    if heatLevel >= 50 then
      fission.deactivate()
    end
    if heatLevel == 0 and state == true then
      fission.activate()
    end
  end
end
 
---- Draw Functions
 
function drawBackgroundBox()
  gpu.setBackground(0x373737)
  gpu.fill(2, 2, 134, 34, " ")
  gpu.setBackground(0x000000)
end
 
function drawButton()
  gpu.setBackground(0xDC143C)
  gpu.fill(3, 25, 49, 10, " ")
  gpu.fill(54, 25, 49, 10, " ")
  gpu.setBackground(0x1F1F1F)
  gpu.fill(104, 6, 30, 5, " ")
  gpu.fill(104, 16, 30, 5, " ")
  gpu.fill(104, 25, 30, 10, " ")
  gpu.setBackground(0x000000)
end
 
function drawOnText(color)
  gpu.setBackground(color)
  term.setCursor(18, 27)
  io.write(" ██████  ███    ██")
  term.setCursor(18, 28)
  io.write("██    ██ ████   ██")
  term.setCursor(18, 29)
  io.write("██    ██ ██ ██  ██")
  term.setCursor(18, 30)
  io.write("██    ██ ██  ██ ██")
  term.setCursor(18, 31)
  io.write(" ██████  ██   ████")
end
 
function drawOffText(color)
  gpu.setBackground(color)
  term.setCursor(66, 27)
  io.write(" ██████  ███████ ███████")
  term.setCursor(66, 28)
  io.write("██    ██ ██      ██")
  term.setCursor(66, 29)
  io.write("██    ██ █████   █████  ")
  term.setCursor(66, 30)
  io.write("██    ██ ██      ██")
  term.setCursor(66, 31)
  io.write(" ██████  ██      ██")
end
 
function drawInputBox()
  gpu.setBackground(0x000000)
  term.setCursor(16, 13)
  io.write("▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄")
  term.setCursor(16, 14)
  io.write("▌Amount of fuel:   ▐")
  term.setCursor(16, 15)
  io.write("▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀")
end
 
function drawCubeNet()
  term.setCursor(18, 18)
  io.write("   ▐▛▀▀▜▌")
  term.setCursor(18, 19)
  io.write("   ▐▌UP▐▌")
  term.setCursor(18, 20)
  io.write("▄▄▄▟▙▄▄▟▙▄▄▄▄▄▄▄")
  term.setCursor(18, 21)
  io.write("▌NH▐▌WT▐▌SH▐▌ET▐")
  term.setCursor(18, 22)
  io.write("▀▀▀▜▛▀▀▜▛▀▀▀▀▀▀▀")
  term.setCursor(18, 23)
  io.write("   ▐▌DN▐▌")
  term.setCursor(18, 24)
  io.write("   ▐▙▄▄▟▌")
end
 
---- Supply Fuel Screen
 
-- Input Box
 
function inputBox(_, _, x, y)
  if typing ~= true then
    if x >= 16 and x <= 36 and y >= 13 and y <= 15 then
      local overwrite = io.open("amountFuel", "w")
      overwrite:write("")
      overwrite:close()
      typing = true
      term.setCursor(33, 14)
      io.write("  ")
      term.setCursor(33, 14)
      repeat
        local key = {term.pull("key_down")}
        if key[3] ~= 8 then
          local fuel = io.open("amountFuel", "a")
          fuel:write(unicode.char(key[3]))
          io.write(unicode.char(key[3]))
          fuel:close()
          count = count + 1
          term.setCursor(34, 14)
        end
      until count == 2
      count = 0
      typing = false
      term.setCursor(33, 14)
      local setVariable = io.open("amountFuel", "r")
      amountFuel = tonumber(setVariable:read())
      setVariable:close()
      if amountFuel == nil then
        amountFuel = 0
      end
      if amountFuel >= 65 then
        amountFuel = 64
      end
      io.write("  ")
      term.setCursor(33, 14)
      io.write(amountFuel)
    end
  end
end
 
-- Cube Net
 
function directionPick(_, _, x, y)
  if x >= 23 and x <= 24 and y == 23 then
    side = 0
  elseif x >= 23 and x <= 24 and y == 19 then
    side = 1
  elseif x >= 19 and x <= 20 and y == 21 then
    side = 2
  elseif x >= 27 and x <= 28 and y == 21 then
    side = 3
  elseif x >= 23 and x <= 24 and y == 21 then
    side = 4
  elseif x >= 31 and x <= 32 and y == 21 then
    side = 5
  end
  if side == 0 then
    drawCubeNet()
    term.setCursor(23, 23)
    io.write("\27[32m", "DN", "\27[37m")
  elseif side == 1 then
    drawCubeNet()
    term.setCursor(23, 19)
    io.write("\27[32m", "UP", "\27[37m")
  elseif side == 2 then
    drawCubeNet()
    term.setCursor(19, 21)
    io.write("\27[32m", "NH", "\27[37m")
  elseif side == 3 then
    drawCubeNet()
    term.setCursor(27, 21)
    io.write("\27[32m", "SH", "\27[37m")
  elseif side == 4 then
    drawCubeNet()
    term.setCursor(23, 21)
    io.write("\27[32m", "WT", "\27[37m")
  elseif side == 5 then
    drawCubeNet()
    term.setCursor(31, 21)
    io.write("\27[32m", "ET", "\27[37m")
  end
end
 
-- Combo Box
 
function summonComboBox(_, _, x, y)
  if openBox ~= true then
    if x >= 53 and x <= 83 and y >= 4 and y <= 9 then
      drawComboBox()
      openBox = true
      while event.pull(0.1, "interrupted") == nil do
        gpu.setForeground(0x000000)
        gpu.setBackground(0xD3D3D3)
        if list >= 10 then
          term.setCursor(61, 9)
          io.write("Page  ", list, " of 13")
        else
          term.setCursor(62, 9)
          io.write("Page ", list, " of 13")
        end
        gpu.setBackground(0xFFFFFF)
        if list == 1 then
          term.setCursor(54, 12)
          io.write("TBU Fuel")
          term.setCursor(54, 17)
          io.write("TBU Oxide Fuel")
          term.setCursor(54, 22)
          io.write("LEU-233 Fuel")
          term.setCursor(54, 27)
          io.write("LEU-233 Oxide Fuel")
        elseif list == 2 then
          term.setCursor(54, 12)
          io.write("HEU-233 Fuel")
          term.setCursor(54, 17)
          io.write("HEU-233 Oxide Fuel")
          term.setCursor(54, 22)
          io.write("LEU-235 Fuel")
          term.setCursor(54, 27)
          io.write("LEU-235 Oxide Fuel")
        elseif list == 3 then
          term.setCursor(54, 12)
          io.write("HEU-235 Fuel")
          term.setCursor(54, 17)
          io.write("HEU-235 Oxide Fuel")
          term.setCursor(54, 22)
          io.write("LEN-236 Fuel")
          term.setCursor(54, 27)
          io.write("LEN-236 Oxide Fuel")
        elseif list == 4 then
          term.setCursor(54, 12)
          io.write("HEN-236 Fuel")
          term.setCursor(54, 17)
          io.write("HEN-236 Oxide Fuel")
          term.setCursor(54, 22)
          io.write("LEP-239 Fuel")
          term.setCursor(54, 27)
          io.write("LEP-239 Oxide Fuel")
        elseif list == 5 then
          term.setCursor(54, 12)
          io.write("HEP-239 Fuel")
          term.setCursor(54, 17)
          io.write("HEP-239 Oxide Fuel")
          term.setCursor(54, 22)
          io.write("LEP-241 Fuel")
          term.setCursor(54, 27)
          io.write("LEP-241 Oxide Fuel")
        elseif list == 6 then
          term.setCursor(54, 12)
          io.write("MOX-239 Fuel")
          term.setCursor(54, 17)
          io.write("MOX-241 Fuel")
          term.setCursor(54, 22)
          io.write("LEA-242 Fuel")
          term.setCursor(54, 27)
          io.write("LEA-242 Oxide Fuel")
        elseif list == 7 then
          term.setCursor(54, 12)
          io.write("HEA-242 Fuel")
          term.setCursor(54, 17)
          io.write("HEA-242 Oxide Fuel")
          term.setCursor(54, 22)
          io.write("LECm-243 Fuel")
          term.setCursor(54, 27)
          io.write("LECm-243 Oxide Fuel")
        elseif list == 8 then
          term.setCursor(54, 12)
          io.write("HECm-243 Fuel")
          term.setCursor(54, 17)
          io.write("HECm-243 Oxide Fuel")
          term.setCursor(54, 22)
          io.write("LECm-245 Fuel")
          term.setCursor(54, 27)
          io.write("LECm-245 Oxide Fuel")
        elseif list == 9 then
          term.setCursor(54, 12)
          io.write("HECm-245 Fuel")
          term.setCursor(54, 17)
          io.write("HECm-245 Oxide Fuel")
          term.setCursor(54, 22)
          io.write("LECm-247 Fuel")
          term.setCursor(54, 27)
          io.write("LECm-247 Oxide Fuel")
        elseif list == 10 then
          term.setCursor(54, 12)
          io.write("HECm-247 Fuel")
          term.setCursor(54, 17)
          io.write("HECm-247 Oxide Fuel")
          term.setCursor(54, 22)
          io.write("LEB-248 Fuel")
          term.setCursor(54, 27)
          io.write("LEB-248 Oxide Fuel")
        elseif list == 11 then
          term.setCursor(54, 12)
          io.write("HEB-248 Fuel")
          term.setCursor(54, 17)
          io.write("HEB-248 Oxide Fuel")
          term.setCursor(54, 22)
          io.write("LECf-249 Fuel")
          term.setCursor(54, 27)
          io.write("LECf-249 Oxide Fuel")
        elseif list == 12 then
          term.setCursor(54, 12)
          io.write("HECf-249 Fuel")
          term.setCursor(54, 17)
          io.write("HECf-249 Oxide Fuel")
          term.setCursor(54, 22)
          io.write("LECf-251 Fuel")
          term.setCursor(54, 27)
          io.write("LECf-251 Oxide Fuel")
        elseif list == 13 then
          term.setCursor(54, 12)
          io.write("HECf-251 Fuel")
          term.setCursor(54, 17)
          io.write("HECf-251 Oxide Fuel")
        end
        local situation = {event.pullMultiple("touch", "scroll")}
        if situation[1] == "touch" then
 
          -- First Box
 
          if list == 1 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 10 and situation[4] <= 14 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "TBU Fuel"
            break
          elseif list == 2 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 10 and situation[4] <= 14 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "HEU-233 Fuel"
            break
          elseif list == 3 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 10 and situation[4] <= 14 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "HEU-235 Fuel"
            break
          elseif list == 4 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 10 and situation[4] <= 14 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "HEN-236 Fuel"
            break
          elseif list == 5 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 10 and situation[4] <= 14 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "HEP-239 Fuel"
            break
          elseif list == 6 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 10 and situation[4] <= 14 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "MOX-239 Fuel"
            break
          elseif list == 7 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 10 and situation[4] <= 14 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "HEA-242 Fuel"
            break
          elseif list == 8 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 10 and situation[4] <= 14 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "HECm-243 Fuel"
            break
          elseif list == 9 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 10 and situation[4] <= 14 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "HECm-245 Fuel"
            break
          elseif list == 10 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 10 and situation[4] <= 14 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "HECm-247 Fuel"
            break
          elseif list == 11 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 10 and situation[4] <= 14 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "HEB-248 Fuel"
            break
          elseif list == 12 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 10 and situation[4] <= 14 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "HECf-249 Fuel"
            break
          elseif list == 13 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 10 and situation[4] <= 14 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "HECf-251 Fuel"
            break
 
            -- Second Box
 
          elseif list == 1 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 15 and situation[4] <= 19 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "TBU Oxide Fuel"
            break
          elseif list == 2 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 15 and situation[4] <= 19 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "HEU-233 Oxide Fuel"
            break
          elseif list == 3 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 15 and situation[4] <= 19 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "HEU-235 Oxide Fuel"
            break
          elseif list == 4 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 15 and situation[4] <= 19 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "HEN-236 Oxide Fuel"
            break
          elseif list == 5 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 15 and situation[4] <= 19 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "HEP-239 Oxide Fuel"
            break
          elseif list == 6 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 15 and situation[4] <= 19 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "MOX-241 Fuel"
            break
          elseif list == 7 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 15 and situation[4] <= 19 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "HEA-242 Oxide Fuel"
            break
          elseif list == 8 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 15 and situation[4] <= 19 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "HECm-243 Oxide Fuel"
            break
          elseif list == 9 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 15 and situation[4] <= 19 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "HECm-245 Oxide Fuel"
            break
          elseif list == 10 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 15 and situation[4] <= 19 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "HECm-247 Oxide Fuel"
            break
          elseif list == 11 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 15 and situation[4] <= 19 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "HEB-248 Oxide Fuel"
            break
          elseif list == 12 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 15 and situation[4] <= 19 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "HECf-249 Oxide Fuel"
            break
          elseif list == 13 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 15 and situation[4] <= 19 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "HECf-251 Oxide Fuel"
            break
 
            -- Third Box
 
          elseif list == 1 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 20 and situation[4] <= 24 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "LEU-233 Fuel"
            break
          elseif list == 2 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 20 and situation[4] <= 24 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "LEU-235 Fuel"
            break
          elseif list == 3 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 20 and situation[4] <= 24 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "LEN-236 Fuel"
            break
          elseif list == 4 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 20 and situation[4] <= 24 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "LEP-239 Fuel"
            break
          elseif list == 5 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 20 and situation[4] <= 24 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "LEP-241 Fuel"
            break
          elseif list == 6 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 20 and situation[4] <= 24 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "LEA-242 Fuel"
            break
          elseif list == 7 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 20 and situation[4] <= 24 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "LECm-243 Fuel"
            break
          elseif list == 8 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 20 and situation[4] <= 24 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "LECm-245 Fuel"
            break
          elseif list == 9 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 20 and situation[4] <= 24 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "LECm-247 Fuel"
            break
          elseif list == 10 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 20 and situation[4] <= 24 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "LEB-248 Fuel"
            break
          elseif list == 11 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 20 and situation[4] <= 24 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "LECf-249 Fuel"
            break
          elseif list == 12 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 20 and situation[4] <= 24 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "LECf-251 Fuel"
            break
 
            -- Fourth Box
 
          elseif list == 1 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 25 and situation[4] <= 30 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "LEU-233 Oxide Fuel"
            break
          elseif list == 2 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 25 and situation[4] <= 30 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "LEU-235 Oxide Fuel"
            break
          elseif list == 3 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 25 and situation[4] <= 30 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "LEN-236 Oxide Fuel"
            break
          elseif list == 4 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 25 and situation[4] <= 30 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "LEP-239 Oxide Fuel"
            break
          elseif list == 5 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 25 and situation[4] <= 30 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "LEP-241 Oxide Fuel"
            break
          elseif list == 6 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 25 and situation[4] <= 30 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "LEA-242 Oxide Fuel"
            break
          elseif list == 7 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 25 and situation[4] <= 30 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "LECm-243 Oxide Fuel"
            break
          elseif list == 8 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 25 and situation[4] <= 30 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "LECm-245 Oxide Fuel"
            break
          elseif list == 9 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 25 and situation[4] <= 30 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "LECm-247 Oxide Fuel"
            break
          elseif list == 10 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 25 and situation[4] <= 30 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "LEB-248 Oxide Fuel"
            break
          elseif list == 11 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 25 and situation[4] <= 30 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "LECf-249 Oxide Fuel"
            break
          elseif list == 12 and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 25 and situation[4] <= 30 then
            drawComboBox(true)
            drawShortComboBox()
            openBox = false
            selectedFuel = "LECf-251 Oxide Fuel"
            break
          end
        end
        if situation[1] == "touch" then
          if not (situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 9 and situation[4] <= 30) then
            drawComboBox(true)
            openBox = false
            break
          end
        elseif situation[1] == "scroll" and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 9 and situation[4] <= 30 and situation[5] == -1 and list ~= 13 then
          drawComboBox()
          list = list + 1
        elseif situation[1] == "scroll" and situation[3] >= 53 and situation[3] <= 83 and situation[4] >= 9 and situation[4] <= 30 and situation[5] == 1 and list ~= 1 then
          drawComboBox()
          list = list - 1
        end
      end
      term.setCursor(54, 6)
      gpu.setBackground(0xFFFFFF)
      gpu.setForeground(0x000000)
      io.write(selectedFuel)
      gpu.setBackground(0x000000)
      gpu.setForeground(0xFFFFFF)
    end
  end
end
 
function drawComboBox(wipe)
  if wipe == true then
    gpu.setBackground(0x000000)
    gpu.fill(53, 9, 30, 21, " ")
  elseif wipe == nil then
    gpu.setBackground(0xD3D3D3)
    gpu.fill(53, 9, 30, 1, " ")
    gpu.setBackground(0xFFFFFF)
    gpu.fill(53, 10, 30, 20, " ")
  end
end
 
function drawShortComboBox()
  gpu.setBackground(0xFFFFFF)
  gpu.fill(53, 4, 30, 5, " ")
end
 
-- Send Fuel Button
 
function drawSendFuel(color)
  gpu.setBackground(color)
  gpu.fill(100, 15, 20, 5, " ")
  term.setCursor(105, 17)
  io.write("Send Fuel")
  gpu.setBackground(0x000000)
end
 
function sendFuel(_, _, x, y)
  if x >= 100 and x <= 120 and y >= 15 and y <= 20 then
    db.clear(1)
    if autoSupplyStatus == true and sendFuelButton == nil then
      if selectedFuel == nil or side == nil then
          throwError("Value(s) empty")
      else
        drawSendFuel(0x00AB66)
        sendFuelButton = true
        me.store({label = selectedFuel}, db.address, 1)
        eb.setExportConfiguration(side, 1, db.address, 1)
        while event.pull(0.1, "interrupted") == nil and sendFuelButton == true do
          eb.exportIntoSlot(side)
        end
      end
    elseif autoSupplyStatus == true and sendFuelButton == true then
      drawSendFuel(0xDC143C)
      sendFuelButton = nil
    elseif autoSupplyStatus == nil then
      drawSendFuel(0x00AB66)
      if event.pull("drop") then
        drawSendFuel(0xDC143C)
        if selectedFuel == nil or amountFuel == 0 or amountFuel == nil or side == nil then
          throwError("Value(s) empty")
        else
          me.store({label = selectedFuel}, db.address, 1, amountFuel)
          eb.setExportConfiguration(side, 1, db.address, 1)
          gpu.setBackground(0x373737)
          gpu.fill(50, 30, 36, 5, " ")
          gpu.setBackground(0xD3D3D3)
          gpu.fill(51, 31, 25, 3, " ")
          while event.pull(0.1, "interrupted") == nil and repeatSend ~= amountFuel do
            if autoSupplyStatus == true then break end
            repeatSend = repeatSend + 1
            eb.exportIntoSlot(side)
            gpu.setBackground(0x1F1F1F)
            gpu.fill(77, 31, 8, 3, " ")
            term.setCursor(77, 31)
            io.write(round((repeatSend/amountFuel)*100, 0), "%")
            term.setCursor(77, 33)
            io.write(repeatSend, " of ", amountFuel)
            gpu.setBackground(0x00FF00)
            gpu.fill(51, 31, (repeatSend/amountFuel)*25, 3, " ")
            gpu.setBackground(0x000000)
          end
          repeatSend = 0
        end
      end
    end
  end
end
 
function toggleAutoSupply(_, _, x, y)
  if x >= 100 and x <= 120 and y == 21 and autoSupplyStatus == true then
    autoSupplyStatus = nil
    drawSendFuel(0xDC143C)
    sendFuelButton = nil
  elseif x >= 100 and x <= 120 and y == 21 and autoSupplyStatus == nil then
    autoSupplyStatus = true
    gpu.setBackground(0x000000)
    gpu.fill(50, 30, 36, 5, " ")
  end
  term.setCursor(100, 21)
  if autoSupplyStatus == true then
    io.write("Auto-Supply: ", "\27[32m", "Enabled ", "\27[37m")
  else
    io.write("Auto-Supply: ", "\27[31m", "Disabled", "\27[37m")
  end
end
 
---- Induction Matrix Screen
 
function drawInductionBar()
  local im = component.induction_matrix
  while event.pull(0.1, "interrupted") == nil do
    if clear == true then break end
 
    -- Variables
 
    local inductionEnergyStored = unit*im.getEnergy()/(unit*im.getMaxEnergy()/100)
    if im.getEnergy() == 0 then
      inductionEnergyStored = 0
    end
    local inductionMaxEnergyStored = unit*im.getMaxEnergy()/(unit*im.getMaxEnergy()/100)
    local inductionRemainingEnergyStored = inductionMaxEnergyStored - inductionEnergyStored
 
    -- Energy Bar
 
    gpu.setBackground(0x00FF00)
    gpu.fill(18, 7, math.floor(inductionEnergyStored+0.5), 20, " ")
    gpu.setBackground(0xD3D3D3)
    gpu.fill(18 + math.floor(inductionEnergyStored+0.5), 7, math.floor(inductionRemainingEnergyStored+0.5), 20, " ")
    gpu.setBackground(0x1F1F1F)
    term.setCursor(18, 29)
    io.write("\27[32m", "ENERGY STORED:", "\27[37m")
    term.setCursor(33, 29)
    if unit == 1 then
      io.write("(EU)")
    elseif unit == 4 then
      io.write("(RF)")
    elseif unit == 10 then
      io.write("    ")
      term.setCursor(33, 29)
      io.write("(J)")
    end
    term.setCursor(18, 31)
    io.write(round(inductionEnergyStored, 3), "%")
    term.setCursor(18, 33)
    io.write(shrink(unit*im.getEnergy()), " out of ", shrink(unit*im.getMaxEnergy()))
 
    -- I/O
 
    term.setCursor(83, 29)
    io.write("\27[35m", "I/O STATISTICS:", "\27[37m")
    term.setCursor(99, 29)
    if unit == 1 then
      io.write("(EU/t)")
    elseif unit == 4 then
      io.write("(RF/t)")
    elseif unit == 10 then
      io.write("      ")
      term.setCursor(99, 29)
      io.write("(J/t)")
    end
    term.setCursor(83, 31)
    io.write("\27[36m", "INPUT: ", "\27[37m", shrink(unit*im.getInput()))
    term.setCursor(83, 33)
    io.write("\27[31m", "OUTPUT: ", "\27[37m", shrink(unit*im.getOutput()))
    if im.getInput() == 0 then
      gpu.fill(91, 31, 27, 1, " ")
    end
    if im.getOutput() == 0 then
      gpu.fill(92, 33, 26, 1, " ")
    end
  end
end
 
function drawInductionBackgroundBox()
  gpu.setBackground(0x373737)
  gpu.fill(17, 6, 102, 22, " ")
  gpu.setBackground(0x1F1F1F)
  gpu.fill(18, 29, 35, 5, " ")
  gpu.fill(83, 29, 35, 5, " ")
  gpu.fill(59, 29, 18, 5, " ")
end
 
function selectEnergyUnit(_, _, x, y)
  if x >= 59 and x <= 77 and y == 31 then
    unit = 1
    gpu.fill(18, 33, 35, 1, " ")
    gpu.fill(83, 31, 35, 3, " ")
  elseif x >= 59 and x <= 77 and y == 32 then
    unit = 4
    gpu.fill(18, 33, 35, 1, " ")
    gpu.fill(83, 31, 35, 3, " ")
  elseif x >= 59 and x <= 77 and y == 33 then
    unit = 10
    gpu.fill(18, 33, 35, 1, " ")
    gpu.fill(83, 31, 35, 3, " ")
  end
  if unit == 1 then
    term.setCursor((136-#"Energy Units  (EU)")/2, 31)
    io.write("\27[32m", "Energy Units  (EU)", "\27[37m")
    term.setCursor((136-#"Redstone Flux (RF)")/2, 32)
    io.write("Redstone Flux (RF)")
    term.setCursor((136-#"Joule (J)")/2, 33)
    io.write("Joule (J)")
  elseif unit == 4 then
    term.setCursor((136-#"Energy Units  (EU)")/2, 31)
    io.write("Energy Units  (EU)")
    term.setCursor((136-#"Redstone Flux (RF)")/2, 32)
    io.write("\27[32m", "Redstone Flux (RF)", "\27[37m")
    term.setCursor((136-#"Joule (J)")/2, 33)
    io.write("Joule (J)")
  elseif unit == 10 then
    term.setCursor((136-#"Energy Units  (EU)")/2, 31)
    io.write("Energy Units  (EU)")
    term.setCursor((136-#"Redstone Flux (RF)")/2, 32)
    io.write("Redstone Flux (RF)")
    term.setCursor((136-#"Joule (J)")/2, 33)
    io.write("\27[32m", "Joule (J)", "\27[37m")
  end
end
 
---- Menu
 
function drawMenu()
  gpu.setBackground(0x1F1F1F)
  gpu.fill(1, 37, 136, 1, " ")
  gpu.setBackground(0x373737)
  term.setCursor(27, 37)
  io.write("Fission Reactor")
  term.setCursor(47, 37)
  io.write("Supply Fuel")
  term.setCursor(63, 37)
  io.write("Induction Matrix")
  term.setCursor(84, 37)
  io.write("Write to Shell")
  term.setCursor(103, 37)
  io.write("Reboot")
end
 
function listenMenu()
  event.listen("touch", checkReboot)
  event.listen("touch", checkSupplyFuel)
  event.listen("touch", checkWriteShell)
  event.listen("touch", checkInductionMatrix)
  event.listen("touch", checkFissionReactor)
end
 
function ignoreTouch()
  event.ignore("touch", checkButtonA)
  event.ignore("touch", checkButtonB)
  event.ignore("touch", checkReboot)
  event.ignore("touch", checkSupplyFuel)
  event.ignore("touch", checkWriteShell)
  event.ignore("touch", checkInductionMatrix)
  event.ignore("touch", checkFissionReactor)
  event.ignore("touch", selectEnergyUnit)
  event.ignore("touch", inputBox)
  event.ignore("touch", summonComboBox)
  event.ignore("touch", sendFuel)
  event.ignore("touch", toggleAutoSupply)
  event.ignore("touch", directionPick)
end
 
---- Screens
 
function screenFission()
  clear = false
  term.clear()
  ignoreTouch()
  drawBackgroundBox()
  drawButton()
  drawOnText(0xDC143C)
  drawOffText(0xDC143C)
  drawMenu()
  event.listen("touch", checkButtonA)
  event.listen("touch", checkButtonB)
  listenMenu()
  drawFissionBar()
end
 
function screenInductionMatrix()
  clear = false
  term.clear()
  ignoreTouch()
  drawMenu()
  listenMenu()
  event.listen("touch", selectEnergyUnit)
  drawInductionBackgroundBox()
  term.setCursor((136-#"UNITS:")/2, 29)
  io.write("\27[33m", "UNITS:", "\27[37m")
  if unit == 1 then
    term.setCursor((136-#"Energy Units  (EU)")/2, 31)
    io.write("\27[32m", "Energy Units  (EU)", "\27[37m")
    term.setCursor((136-#"Redstone Flux (RF)")/2, 32)
    io.write("Redstone Flux (RF)")
    term.setCursor((136-#"Joule (J)")/2, 33)
    io.write("Joule (J)")
  elseif unit == 4 then
    term.setCursor((136-#"Energy Units  (EU)")/2, 31)
    io.write("Energy Units  (EU)")
    term.setCursor((136-#"Redstone Flux (RF)")/2, 32)
    io.write("\27[32m", "Redstone Flux (RF)", "\27[37m")
    term.setCursor((136-#"Joule (J)")/2, 33)
    io.write("Joule (J)")
  elseif unit == 10 then
    term.setCursor((136-#"Energy Units  (EU)")/2, 31)
    io.write("Energy Units  (EU)")
    term.setCursor((136-#"Redstone Flux (RF)")/2, 32)
    io.write("Redstone Flux (RF)")
    term.setCursor((136-#"Joule (J)")/2, 33)
    io.write("\27[32m", "Joule (J)", "\27[37m")
  end
  drawInductionBar()
end
 
function screenSupplyFuel()
  clear = false
  term.clear()
  ignoreTouch()
  if component.isAvailable("me_interface") then
    me = component.me_interface
  elseif component.isAvailable("me_controller") then
    me = component.me_controller
  end
  eb = component.me_exportbus
  db = component.database
  drawMenu()
  listenMenu()
  drawInputBox()
  if side == nil then
    drawCubeNet()
  elseif side == 0 then
    drawCubeNet()
    term.setCursor(23, 23)
    io.write("\27[32m", "DN", "\27[37m")
  elseif side == 1 then
    drawCubeNet()
    term.setCursor(23, 19)
    io.write("\27[32m", "UP", "\27[37m")
  elseif side == 2 then
    drawCubeNet()
    term.setCursor(19, 21)
    io.write("\27[32m", "NH", "\27[37m")
  elseif side == 3 then
    drawCubeNet()
    term.setCursor(27, 21)
    io.write("\27[32m", "SH", "\27[37m")
  elseif side == 4 then
    drawCubeNet()
    term.setCursor(23, 21)
    io.write("\27[32m", "WT", "\27[37m")
  elseif side == 5 then
    drawCubeNet()
    term.setCursor(31, 21)
    io.write("\27[32m", "ET", "\27[37m")
  end
  event.listen("touch", inputBox)
  event.listen("touch", summonComboBox)
  event.listen("touch", sendFuel)
  event.listen("touch", toggleAutoSupply)
  event.listen("touch", directionPick)
  drawShortComboBox()
  drawSendFuel(0xDC143C)
  if selectedFuel ~= nil then
    term.setCursor(54, 6)
    gpu.setBackground(0xFFFFFF)
    gpu.setForeground(0x000000)
    io.write(selectedFuel)
    gpu.setBackground(0x000000)
    gpu.setForeground(0xFFFFFF)
  end
  term.setCursor(33, 14)
  io.write(amountFuel)
  term.setCursor(100, 21)
  if autoSupplyStatus == true then
    io.write("Auto-Supply: ", "\27[32m", "Enabled ", "\27[37m")
  else
    io.write("Auto-Supply: ", "\27[31m", "Disabled", "\27[37m")
  end
  while event.pull(0.1, "interrupted") == nil do if clear == true then break end end
end
 
---- Start Program
 
function selectProgram()
  function drawSelection()
    gpu.setBackground(0x1F1F1F)
    term.setCursor((28-#"  Fission  Reactor  ")/2, 3)
    io.write("  Fission  Reactor  ")
    term.setCursor((28-#"  Supply  Fuel  ")/2, 5)
    io.write("  Supply  Fuel  ")
    term.setCursor((28-#"  Induction Matrix  ")/2, 7)
    io.write("  Induction Matrix  ")
    term.setCursor((28-#"  Write to Shell  ")/2, 9)
    io.write("  Write to Shell  ")
    term.setCursor((28-#"  Reboot  ")/2, 11)
    io.write("  Reboot  ")
  end
  drawSelection()
  while true do
    local cursor = {event.pull("key_down")}
    if cursor[4] == 0x1C and option ~= 0 then
      if option == 1 then
        if component.isAvailable("nc_fission_reactor") then
          term.clear()
          gpu.setResolution(136, 37)
          gpu.setBackground(0x000000)
          screenFission()
          break
        else
          throwError("Component(s) unavailable", true)
        end
      elseif option == 2 then
        if component.isAvailable("me_exportbus") and component.isAvailable("database") and component.isAvailable("nc_fission_reactor") then
          if component.isAvailable("me_controller") or component.isAvailable("me_interface") then
            term.clear()
            gpu.setResolution(136, 37)
            gpu.setBackground(0x000000)
            screenSupplyFuel()
            break
          else
            throwError("Component(s) unavailable", true)
          end
        else
          throwError("Component(s) unavailable", true)
        end
      elseif option == 3 then
        if component.isAvailable("induction_matrix") then
          term.clear()
          gpu.setResolution(136, 37)
          gpu.setBackground(0x000000)
          screenInductionMatrix()
          break
        else
          throwError("Component(s) unavailable", true)
        end
      elseif option == 4 then
        local shell = io.open(".shrc", "w")
        shell:write("/home/fission.lua")
        shell:close()
      elseif option == 5 then
        computer.shutdown(true)
      end
    end
    if cursor[4] == 0xD0 and option == 0 then
      drawSelection()
      term.setCursor((28-#"> Fission  Reactor <")/2, 3)
      io.write("> Fission  Reactor <")
      option = option + 1
    elseif cursor[4] == 0xD0 and option == 1 then
      drawSelection()
      term.setCursor((28-#"> Supply  Fuel <")/2, 5)
      io.write("> Supply  Fuel <")
      option = option + 1
    elseif cursor[4] == 0xD0 and option == 2 then
      drawSelection()
      term.setCursor((28-#"> Induction Matrix <")/2, 7)
      io.write("> Induction Matrix <")
      option = option + 1
    elseif cursor[4] == 0xD0 and option == 3 then
      drawSelection()
      term.setCursor((28-#"> Write to Shell <")/2, 9)
      io.write("> Write to Shell <")
      option = option + 1
    elseif cursor[4] == 0xD0 and option == 4 then
      drawSelection()
      term.setCursor((28-#"> Reboot <")/2, 11)
      io.write("> Reboot <")
      option = option + 1
    elseif cursor[4] == 0xC8 and option == 0 then
      drawSelection()
      term.setCursor((28-#"> Reboot <")/2, 11)
      io.write("> Reboot <")
      option = option + 5
    elseif cursor[4] == 0xC8 and option == 2 then
      drawSelection()
      term.setCursor((28-#"> Fission  Reactor <")/2, 3)
      io.write("> Fission  Reactor <")
      option = option - 1
    elseif cursor[4] == 0xC8 and option == 3 then
      drawSelection()
      term.setCursor((28-#"> Supply  Fuel <")/2, 5)
      io.write("> Supply  Fuel <")
      option = option - 1
    elseif cursor[4] == 0xC8 and option == 4 then
      drawSelection()
      term.setCursor((28-#"> Induction Matrix <")/2, 7)
      io.write("> Induction Matrix <")
      option = option - 1
    elseif cursor[4] == 0xC8 and option == 5 then
      drawSelection()
      term.setCursor((28-#"> Write to Shell <")/2, 9)
      io.write("> Write to Shell <")
      option = option - 1
    end
  end
end
 
term.clear()
gpu.setResolution(26, 13)
gpu.setBackground(0x373737)
gpu.fill(3, 2, 22, 11, " ")
gpu.setBackground(0x1F1F1F)
gpu.fill(4, 3, 20, 9, " ")
selectProgram()
