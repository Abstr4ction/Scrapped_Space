-----------------------------------------------------------------------------------------
--
-- main.lua
-- TEST Group 9
-----------------------------------------------------------------------------------------
-- Your code here
widget = require( "widget" )
local composer = require("composer")
csv = require("csv")
display.setStatusBar(display.HiddenStatusBar)
math.randomseed(os.time())		-- helps with random generator?

-- **************************************************************************************************************
-- audio channels are reserved here with volume changes
audio.reserveChannels(1)
audio.setVolume( 0.20, { channel=1})

audio.reserveChannels(2)
audio.setVolume(0.10 , { channel = 2 } )

audio.reserveChannels(3)
audio.setVolume(0.10 , { channel = 3 } )

composer.gotoScene("Menu")