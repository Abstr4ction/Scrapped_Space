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

audio.reserveChannels(1)
audio.setVolume( 0.20, { channel=1})

audio.reserveChannels(2)
audio.setVolume(0.10 , { channel = 2 } )

composer.gotoScene("Menu")