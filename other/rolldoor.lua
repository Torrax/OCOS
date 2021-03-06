component = require("component")
scanRange = 2

while true do
  output = component.os_rfidreader.scan(scanRange)
  if output[1] ~= nil then
    if output[1].data == "Kd3J97s3DkRyi28D2" then
      print ("Access Granted: ")
      print (output[1].name)
      component.os_rolldoorcontroller.open()
    else
      component.os_rolldoorcontroller.close()
    end  
  else
    component.os_rolldoorcontroller.close()
  end
end
