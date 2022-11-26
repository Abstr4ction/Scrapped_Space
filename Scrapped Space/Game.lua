local composer = require( "composer" )
local scene = composer.newScene()
local physics = require ("physics")
physics.start( )

physics.setGravity( 0, 0 )


 
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here

local background = display.newGroup()
local GUI = display.newGroup()
local main = display.newGroup()


 
---------------------------------------------------------------------------------
 local lives = 3
 local score = 0
 local died = false

 local mainBody
 --sceneGroup:insert(mainBody)

 local livesText
 local scoreText

 local explosionSound
 local shipFire
 local musicTrack

 local shootCH



 function pauseB(event)

end

 local shipOpt = {
   frames = {
      {x = 26, y = 16, width = 77, height = 86}, -- frame 1 (ship points)
      {x = 153, y = 16, width = 77, height = 86} -- frame 2 (ship)
   }
}

local shipSheet = graphics.newImageSheet("HydraShip.png", shipOpt)

local shot3Opt = {
   frames = {
      {x = 5, y = 4, width = 6, height = 11}, -- frame 1 (shot3 )
      --{x = 153, y = 16, width = 77, height = 86} -- frame 2 (ship)
   }
}

local shot3Sheet = graphics.newImageSheet("Shot3.png", shot3Opt)

--soundTable = {

  -- shotSound = audio.loadSound("shoot.wav")

--}





-- "scene:create()"
function scene:create( event )

   background = self.view
 
   local sceneGroup = self.view



      local spaceBackground = display.newImageRect(background, "space.png", 1200, 1200)
      spaceBackground.x = display.contentCenterX
      spaceBackground.y = display.contentCenterY
      spaceBackground.anchorX = 0.5;
      spaceBackground.anchorY = 0.5;
      spaceBackground.xScale = 1.5;
      spaceBackground.yScale = 1.5;
      spaceBackground:toBack( );



 
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   musicTrack = audio.loadStream( "wave.mp3")
   shootCH = audio.loadSound( "shoot.wav" )
end
 
-- "scene:show()"
function scene:show( event )
 
   background = self.view

   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.

      audio.play(musicTrack, { channel=1, loops=-1 } )


      mainBody = display.newImage(shipSheet, 2) --77,86);
      mainBody.anchorX = 0.5;
      mainBody.anchorY = 0.5;
      mainBody.x = display.contentCenterX;
      mainBody.y = display.contentCenterY + 400;
      mainBody.xScale = 1.5;
      mainBody.yScale = 1.5;
      mainBody:toFront();
      sceneGroup:insert(mainBody)
      mainBody.myName = "ship"

   local function fireShot3 ()
      local newShot = display.newImageRect(shot3Sheet, 1, 6,11)
      physics.addBody(newShot, "dynamic", {isSensor = true})
      audio.play(shootCH, {channel = 2})
      print("Tap")
      newShot.isBullet = true
      newShot.myName = "shot3"
      newShot.xScale = 2.0
      newShot.yScale = 2.0
      newShot.x = mainBody.x
      newShot.y = mainBody.y
      sceneGroup:insert( newShot )

      transition.to(newShot, {y = -40, time = 500, 
                  onComplete = function() display.remove(newShot) end })

   end

      --fireButton:addEventListener("tap", fireShot3)


      physics.addBody( mainBody ,"dynamic", {radius = 30 })

      local pauseButton = widget.newButton(
      {
         x = 550,
         y = 20,
         id = "button1",
         label = "PAUSE",
         fontSize = 40
      }
      )
      pauseButton:toFront();
      sceneGroup:insert(pauseButton)


      local fireButton = widget.newButton(
      {
         x = 90,
         y = display.contentHeight+15,
         id = "button1",
         label = "FIRE!",
         fontSize = 40,

         shape = "circle",
         radius = 70,
         onEvent = fireShot3
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
 
   background = self.view
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.

      -- timer.cancel( LoopTimer)

   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.

      -- Runtime:removeEventListener( " collision", onCollision)
      -- physics.pause()
      -- audio.stop(1)
      -- composer.removeScene("Game")
   end
end
 
-- "scene:destroy()"
function scene:destroy( event )
 
   local sceneGroup = self.view

   local background = self.view

   audio.dispose(musicTrack)
 
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