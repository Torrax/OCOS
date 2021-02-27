-- REDBoardControl ver 1.2 ENG by Laine_prikol
forms=require("forms")
local term = require("term")
local sides = require("sides")
local computer = require("computer")
local component = require("component")
local rs = component.redstone
rs.setOutput(sides.south, 0)
 
Form1=forms.addForm()
Form1.border=2
term.setCursor(2,2)
-- authors
Label1=Form1:addLabel(30,25,"Program author: Laine_prikol Author API: Zer0Galaxy")
Label1=Form1:addLabel(2,1,"REDBOARD Control ver 1.2")
-- Panel 1
Label1=Form1:addLabel(2,2,"Contol front side:")
Btn1=Form1:addButton(2,3,"ON",function() rs.setOutput(sides.south, 15) computer.beep(600,0.5)  end) 
Btn1.color=0xfffff                       
Btn2=Form1:addButton(2,4,"OFF",function() rs.setOutput(sides.south, 0) computer.beep(100,0.8) end) 
Btn2.color=0xff0000
Btn3=Form1:addButton(2,5,"Cycle",function() while true do rs.setOutput(sides.south, 0) rs.setOutput(sides.south, 15) os.sleep(0.5) end   end)
Btn3.color=0x505050
-- Panel 2
Label1=Form1:addLabel(2,6,"Contol left side:")
Btn4=Form1:addButton(2,7,"ON",function() rs.setOutput(sides.west, 15) computer.beep(600,0.5)  end) 
Btn4.color=0xfffff
Btn5=Form1:addButton(2,8,"OFF",function() rs.setOutput(sides.west, 0) computer.beep(100,0.8) end) 
Btn5.color=0xff0000
Btn6=Form1:addButton(2,9,"Cycle",function() while true do rs.setOutput(sides.west, 0) rs.setOutput(sides.west, 15) end os.sleep(0.5)  end)
Btn6.color=0x505050
-- Panel 3
Label1=Form1:addLabel(2,10,"Control back side")
Btn7=Form1:addButton(2,11,"ON ",function() rs.setOutput(sides.north, 15) computer.beep(600,0.5)  end) 
Btn7.color=0xfffff
Btn8=Form1:addButton(2,12,"OFF",function() rs.setOutput(sides.north, 0) computer.beep(100,0.8) end) 
Btn8.color=0xff0000
Btn9=Form1:addButton(2,13,"Cycle",function() while true do rs.setOutput(sides.north, 0) rs.setOutput(sides.north, 15) os.sleep(0.5) end   end)
Btn9.color=0x505050
-- Panel 4
Label1=Form1:addLabel(40,2,"Contol right side")
Btn10=Form1:addButton(40,3,"ON ",function() rs.setOutput(sides.east, 15) computer.beep(600,0.5)  end) 
Btn10.color=0xfffff
Btn11=Form1:addButton(40,4,"OFF",function() rs.setOutput(sides.east, 0) computer.beep(100,0.8) end) 
Btn11.color=0xff0000
Btn12=Form1:addButton(40,5,"Cycle",function() while true do rs.setOutput(sides.east, 0) rs.setOutput(sides.east, 15) end os.sleep(0.5)  end)
Btn12.color=0x505050
Label1=Form1:addLabel(40,9,"Miscellaneous:")
Btn1=Form1:addButton(40,10,"ALARM",function() while true do computer.beep(775,0.5) end os.sleep(0.5)  end) 
Btn1.color=0xfffff
Btn1=Form1:addButton(40,11,"EXIT",function() forms.stop() term.clear() end)
Btn1.color=0x505050
forms.run(Form1) -- Load Form1
