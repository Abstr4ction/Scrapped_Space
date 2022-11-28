local composer = require( "composer" )
local scene = composer.newScene()
local physics = require ("physics")
local moving = 0;
physics.start( )

physics.setGravity( 0, 0 )


 
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here

local background 
local GUI 
local main 



 
---------------------------------------------------------------------------------
 local lives = 3
 local score = 0
 local died = false
 local firing = false
 local bodyExists = false

 local mainBody
 --sceneGroup:insert(mainBody)

 local livesText
 local scoreText

 local explosionSound
 local shipFire
 local musicTrack

 local shootCH



function gotoMenu(event)
   firing = false
   bodyExists = false
      composer.gotoScene("Menu", 
     {
         effect = "slideUp",
         time = 100,
      })
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

local function fireShot3 ()
   if firing == true then --random conditional statements that kind of work but also kind of dont :)
      if bodyExists == true then
         local newShot = display.newImageRect(shot3Sheet, 1, 6,11)
         physics.addBody(newShot, "dynamic", {isSensor = true})
         audio.play(shootCH, {channel = 2})
         --print("Tap")
         newShot.isBullet = true
         newShot.myName = "shot3"
         newShot.xScale = 2.0
         newShot.yScale = 2.0
         newShot.x = mainBody.x
         newShot.y = mainBody.y
         --sceneGroup:insert( newShot )

         transition.to(newShot, {y = -40, time = 500, 
                     onComplete = function() display.remove(newShot) end })
      end
   end
end

   -- Display lives and score


     -- sceneGroup:insert(livesText);
     -- sceneGroup:insert(scoreText);

      local function updateText()
         livesText.text = "Lives: "..lives
         scoreText.text = "Score: "..score
      end

local function endGame()
   composer.setVariable( "finalScore", score )
   composer.removeScene("Scoreboard")
   composer.gotoScene( "Scoreboard" )

end

function pickup(event)
   if(event.phase == "began") then
      moving = event.target.id
   elseif(event.phase == "moved") then
      event.target.x = event.x
      event.target.y = event.y
   end
   return true
end

timer.performWithDelay(300, fireShot3, 0) --shoots every 300 ms





-- "scene:create()"
function scene:create( event )

   background = self.view
 
   local sceneGroup = self.view

   physics.pause()

   background = display.newGroup()
   sceneGroup:insert(background)

   GUI = display.newGroup()
   sceneGroup:insert(GUI)

   main = display.newGroup()
   sceneGroup:insert(main)



      local spaceBackground = display.newImageRect(background, "space.png", 1200, 1200)
      spaceBackground.x = display.contentCenterX
      spaceBackground.y = display.contentCenterY
      spaceBackground.anchorX = 0.5;
      spaceBackground.anchorY = 0.5;
      spaceBackground.xScale = 1.5;
      spaceBackground.yScale = 1.5;
      spaceBackground:toBack( );


      livesText = display.newText(GUI,"Lives: "..lives, 200, 80, native.systemFont, 36)
      scoreText = display.newText(GUI,"Score: "..score, 400, 80, native.systemFont, 36)


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
      bodyExists = true

   physics.addBody( mainBody ,"dynamic", {radius = 30 })
 
      mainBody:addEventListener("touch",pickup)
      mainBody.id = 1



 
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
      firing = true
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.

      physics.start()

      audio.play(musicTrack, { channel=1, loops=-1 } )


      local pauseButton = widget.newButton(
      {
         x = 550,
         y = 20,
         id = "button1",
         label = "PAUSE",
         fontSize = 40,
         onEvent = gotoMenu
      }
      )
      pauseButton:toFront();
      GUI:insert(pauseButton)


      --local fireButton = widget.newButton(
      --{
         --x = 90,
         --y = display.contentHeight+15,
         --id = "button1",
         --label = "FIRE!",
         --fontSize = 40,

         --shape = "circle",
         --radius = 70,
         --onEvent = fireShot3
      --}
      --)
      --GUI:insert(fireButton);



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
       physics.pause()
       audio.stop(1)
       composer.removeScene("Game")
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
