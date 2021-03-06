component = require("component")
scanRange = 2

while true do
  output = component.os_rfidreader.scan(scanRange)
  if output[1] ~= nil then
    if output[1].data == "Kd3J97s3DkRyi28D2" then
      print ("Access Granted: ")
      print (output[1].name)
      component.redstone.setOutput(sides.north, 1)
      component.os_rolldoorcontroller.open()
    else
      component.redstone.setOutput(sides.north, 0)
      component.os_rolldoorcontroller.close()
    end  
  else
    component.redstone.setOutput(sides.north, 0)
    component.os_rolldoorcontroller.close()
  end
end
