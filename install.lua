local REPOSITOTY = "https://raw.githubusercontent.com/Torrax/OCOS/main"

local shell = require("shell")
-- Libraries
shell.execute("wget -fq " .. REPOSITOTY .. "/lib/image.lua /lib/image.lua")
shell.execute("wget -fq " .. REPOSITOTY .. "/lib/doubleBuffering.lua /lib/doubleBuffering.lua")
shell.execute("wget -fq " .. REPOSITOTY .. "/lib/gui.lua /lib/gui.lua")
shell.execute("wget -fq " .. REPOSITOTY .. "/lib/forms.lua /lib/forms.lua")

-- Scripts
shell.execute("wget -fq " .. REPOSITOTY .. "/ui.lua /home/ui.lua")
--shell.execute("wget -fq " .. REPOSITOTY .. "/ui.lua /autorun.lua")

shell.execute("mkdir /usr/apps")
shell.execute("wget -fq " .. REPOSITOTY .. "/apps/stocker.lua /usr/apps/stocker.lua")
--shell.execute("wget -fq " .. REPOSITOTY .. "/apps/iFace.lua /usr/apps/iFace.lua")
shell.execute("wget -fq " .. REPOSITOTY .. "/apps/nuclearControl.lua /usr/apps/nuclearControl.lua")
--shell.execute("wget -fq " .. REPOSITOTY .. "/apps/droneControl.lua /usr/apps/droneControl.lua")
--shell.execute("wget -fq " .. REPOSITOTY .. "/apps/securityPanel.lua /usr/apps/securityPanel.lua")
shell.execute("wget -fq " .. REPOSITOTY .. "/apps/remoteRedstone.lua /usr/apps/remoteRedstone.lua")
shell.execute("wget -fq " .. REPOSITOTY .. "/apps/battery.lua /usr/apps/battery.lua")

-- Images
shell.execute("mkdir /home/images")
shell.execute("wget -fq " .. REPOSITOTY .. "/images/torUI.pic /home/images/torUI.pic")
shell.execute("wget -fq " .. REPOSITOTY .. "/images/app_Stocker.pic /home/images/app_Stocker.pic")
shell.execute("wget -fq " .. REPOSITOTY .. "/images/app_iFace.pic /home/images/app_iFace.pic")
shell.execute("wget -fq " .. REPOSITOTY .. "/images/app_securityPanel.pic /home/images/app_securityPanel.pic")
shell.execute("wget -fq " .. REPOSITOTY .. "/images/app_nuclearController.pic /home/images/app_nuclearController.pic")
shell.execute("wget -fq " .. REPOSITOTY .. "/images/app_droneControl.pic /home/images/app_droneControl.pic")
shell.execute("wget -fq " .. REPOSITOTY .. "/images/app_remoteRedstone.pic /home/images/app_remoteRedstone.pic")
