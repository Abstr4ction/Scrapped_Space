local composer = require( "composer" )
local scene = composer.newScene()
 
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here
 
---------------------------------------------------------------------------------
function gotoGame(event)
      composer.gotoScene("Game", 
     {
         effect = "slideUp",
         time = 100,
      })
end
function gotoMenu(event)
      composer.gotoScene("Menu", 
     {
         effect = "slideUp",
         time = 100,
      })
end


-- "scene:create()"
function scene:create( event )
 
   local sceneGroup = self.view
   local gameButton = widget.newButton(
   {
   x = display.contentCenterX*(1/2),
   y = display.contentHeight*(15/16),
   id = "button1",
   label = "Return",
   fontSize = 40,
   onEvent = gotoMenu
   }
   )
   local scoreButton = widget.newButton(
   {
   x = display.contentCenterX*(3/2),
   y = display.contentHeight*(15/16),
   id = "button2",
   label = "Play!",
   fontSize = 40,
   onEvent = gotoGame
   }
   )
   sceneGroup:insert(gameButton)
   sceneGroup:insert(scoreButton)
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end
 
-- "scene:show()"
function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
   end
end
 
-- "scene:hide()"
function scene:hide( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end
end
 
-- "scene:destroy()"
function scene:destroy( event )
 
   local sceneGroup = self.view
 
   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end
 
---------------------------------------------------------------------------------
 
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
---------------------------------------------------------------------------------
 
return scene