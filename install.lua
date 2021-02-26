local REPOSITOTY = "https://raw.githubusercontent.com/Torrax/OCOS/main"

local shell = require("shell")
-- Libraries
shell.execute("wget -fq " .. REPOSITOTY .. "/libs/Image.lua /lib/Image.lua")
shell.execute("wget -fq " .. REPOSITOTY .. "/libs/doubleBuffering.lua /lib/doubleBuffering.lua")
shell.execute("wget -fq " .. REPOSITOTY .. "/libs/GUI.lua /lib/GUI.lua")

-- Scripts
shell.execute("wget -fq " .. REPOSITOTY .. "/ui.lua /home/ui.lua")
--shell.execute("wget -fq " .. REPOSITOTY .. "/ui.lua /autorun.lua")

-- Images
shell.execute("wget -fq " .. REPOSITOTY .. "/images/torUI.lua /home/images/torUI.pic")
