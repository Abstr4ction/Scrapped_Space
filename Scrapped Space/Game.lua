local composer = require( "composer" )
local scene = composer.newScene()
 
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here
 
---------------------------------------------------------------------------------
 local lives = 3
 local score = 0
 local died = false

 local livesText
 local scoreText

 local shipOpt = {
   frames = {
      {x = 26, y = 16, width = 77, height = 86}, -- frame 1 (ship points)
      {x = 153, y = 16, width = 77, height = 86} -- frame 2 (ship)
   }
}

local shipSheet = graphics.newImageSheet("HydraShip.png", shipOpt)





-- "scene:create()"
function scene:create( event )
 
   local sceneGroup = self.view
      local pauseButton = widget.newButton(
      {
         x = 550,
         y = 20,
         id = "button1",
         label = "PAUSE",
         fontSize = 40
      }
      )
      sceneGroup:insert(pauseButton); 
      --local background = display.newImageRect("spacebackground.png", 640, 1140)
     -- background.x = display.contentCenterX
      --background.y = display.contentCenterY
     -- sceneGroup:insert(background)

 
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

      local mainBody = display.newImage(shipSheet, 2);
      sceneGroup:insert(mainBody)
      mainBody.anchorX = 0.5;
      mainBody.anchorY = 0.5;
      mainBody.x = display.contentCenterX;
      mainBody.y = display.contentCenterY + 400;
      mainBody.xScale = 1.5;
      mainBody.yScale = 1.5;


      local fireButton = widget.newButton(
      {
         x = 90,
         y = display.contentHeight+15,
         id = "button1",
         label = "FIRE!",
         fontSize = 40,

         shape = "circle",
         radius = 70
      }
      )
      sceneGroup:insert(fireButton);

-- Display lives and score

      livesText = display.newText("Lives: "..lives, 200, 80, native.systemFont, 36)
      scoreText = display.newText("Score: "..score, 400, 80, native.systemFont, 36)

      sceneGroup:insert(livesText);
      sceneGroup:insert(scoreText);

      local function updateText()
         livesText.text = "Lives: "..lives
         scoreText.text = "Score: "..score
      end




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