local composer = require( "composer" )
local scene = composer.newScene()
local bgimage
 
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here
 
---------------------------------------------------------------------------------
 
-- "scene:create()"
function gotoScoreboard(event)

   composer.removeScene("Scoreboard")
      composer.gotoScene("Scoreboard", 
     {
         effect = "slideUp",
         time = 100,
      })
end
function gotoPregame(event)
      composer.gotoScene("Pregame", 
     {
         effect = "slideUp",
         time = 100,
      })
end


function scene:create( event )
 
   local sceneGroup = self.view
   bgimage = display.newImageRect("space1.png", 1779, 1300)
   bgimage.x = display.contentCenterX
   bgimage.y = display.contentCenterY
   bgimage.anchorX = 0.5;
   bgimage.anchorY = 0.5;
   bgimage.xScale = 1.25;
   bgimage.yScale = 1.25;
   bgimage:toBack( );

   title = display.newImageRect("title.png", 661, 377)
   title.x = display.contentCenterX
   title.y = 150

   local gameButton = widget.newButton(
   {
   x = display.contentCenterX,
   y = 400,
   width = 300,
   height = 100,
   id = "button1",

   defaultFile = "play.png",
   onPress = gotoPregame
   }
   )

   local scoreButton = widget.newButton(
   {
   x = display.contentCenterX,
   y = display.contentHeight*(5/6),
   width = 300,
   height = 100,
   id = "button2",
   --label = "Scoreboard",
   --fontSize = 40,
   defaultFile = "scoreboard.png",
   onPress = gotoScoreboard
   }
   )
   --local gamebtn = newImageRect( [sceneGroup], "play.png", [system.ResourceDirectory], width, height )
   sceneGroup:insert(bgimage)
   sceneGroup:insert(title)
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