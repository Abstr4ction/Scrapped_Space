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

 local lives = 3
 local score = 0
 local died = false
 local firing = false
 local bodyExists = false
 local mainBody
 local asteroidsTable = {}
 local enemiesTable = {}
 local enemyLoopTimer
 local gameLoopTimer
 local livesText
 local scoreText
 local explosionSound
 local shipFire
 local musicTrack
 local shootCH



function gotoMenu(event)
   firing = false
   bodyExists = false
   composer.removeScene("Menu")
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

 local enemy1Opt = {
   frames = {
      {x = 22, y = 13, width = 84, height = 93} -- frame 1 (enemy1)

   }
}

local enemy1Sheet = graphics.newImageSheet("Enemy01.png", enemy1Opt)

local shot3Opt = {
   frames = {
      {x = 5, y = 4, width = 6, height = 11}, -- frame 1 (shot3 )
      --{x = 153, y = 16, width = 77, height = 86} -- frame 2 (ship)
   }
}

local shot3Sheet = graphics.newImageSheet("Shot3.png", shot3Opt)

local sheetOptions =
{
    frames =
    {
        {   -- 1) asteroid 1
            x = 0,
            y = 0,
            width = 102,
            height = 85
        },
        {   -- 2) asteroid 2
            x = 0,
            y = 85,
            width = 90,
            height = 83
        },
        {   -- 3) asteroid 3
            x = 0,
            y = 168,
            width = 100,
            height = 97
        },
    },
}

local asteroidSheet = graphics.newImageSheet( "gameObjects.png", sheetOptions )

--soundTable = {

  -- shotSound = audio.loadSound("shoot.wav")

--}

local function fireShot3 ()
   if firing == true then --random conditional statements that kind of work but also kind of dont :)
      if bodyExists == true then
         local newShot = display.newImageRect(main, shot3Sheet, 1, 6,11)
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

         transition.to(newShot, {y = -40, time = 600, 
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
   firing = false
   bodyExists = false
   composer.setVariable( "finalScore", score )
   composer.removeScene("Scoreboard")
   composer.gotoScene( "Scoreboard" )

end

function pickup(event)
   if (event.target.y >= display.contentCenterY + 210) then
      if(event.phase == "began") then
         moving = event.target.id
      elseif(event.phase == "moved") then
         event.target.x = event.x
         event.target.y = event.y
      end
      return true
   else 
      event.target.y = event.target.y + 5 --pushes ship back down if it's too far up
   end
end

local function createAsteroid()
 
   local newAsteroid = display.newImageRect (main, asteroidSheet, 1, 102, 85 )
   table.insert( asteroidsTable, newAsteroid )
   physics.addBody( newAsteroid, "dynamic", { radius=40, bounce=0.8 } )
   newAsteroid.myName = "asteroid"

   local whereFrom = math.random( 3 )
 
      if ( whereFrom == 1 ) then
         newAsteroid.x = -60
         newAsteroid.y = math.random( 500 )
         newAsteroid:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
 
      elseif ( whereFrom == 2 ) then
        -- From the top
         newAsteroid.x = math.random( display.contentWidth )
         newAsteroid.y = -60
         newAsteroid:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
      elseif ( whereFrom == 3 ) then
        -- From the right
         newAsteroid.x = display.contentWidth + 60
         newAsteroid.y = math.random( 500 )
         newAsteroid:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
      end

      newAsteroid:applyTorque( math.random( -6,6 ) )
end

local function gameLoop()
 
    -- Create new asteroid
    createAsteroid()

    for i = #asteroidsTable, 1, -1 do
        local thisAsteroid = asteroidsTable[i]
 
        if ( thisAsteroid.x < -100 or
             thisAsteroid.x > display.contentWidth + 100 or
             thisAsteroid.y < -100 or
             thisAsteroid.y > display.contentHeight + 100 )
        then
            display.remove( thisAsteroid )
            table.remove( asteroidsTable, i )
        end
    end
end



local function createEnemy()
 
   local newEnemy = display.newImageRect (main, enemy1Sheet, 1, 84, 93 )
   table.insert( enemiesTable, newEnemy )
   physics.addBody( newEnemy, "dynamic", { radius=40, bounce=0.8 } )
   newEnemy.myName = "Enemy"

   local whereFrom = math.random( 3 )
 
      if ( whereFrom == 1 ) then
         newEnemy.x = -60
         newEnemy.y = math.random( 500 )
         newEnemy:setLinearVelocity( 0, math.random( 20,60 ) )
 
      elseif ( whereFrom == 2 ) then
        -- From the top
         newEnemy.x = math.random( display.contentWidth )
         newEnemy.y = -60
         newEnemy:setLinearVelocity( 0, math.random( 40,120 ) )
      elseif ( whereFrom == 3 ) then
        -- From the right
         newEnemy.x = display.contentWidth + 60
         newEnemy.y = math.random( 500 )
         newEnemy:setLinearVelocity( 0 , math.random( 20,60 ) )
      end


end


local function enemyLoop()
 
    -- Create new asteroid
    createEnemy()

    for i = #enemiesTable, 1, -1 do
        local thisEnemy = enemiesTable[i]
 
        if ( thisEnemy.x < -100 or
             thisEnemy.x > display.contentWidth + 100 or
             thisEnemy.y < -100 or
             thisEnemy.y > display.contentHeight + 100 )
        then
            display.remove( thisEnemy )
            table.remove( enemiesTable, i )
        end
    end
end

local function restoreShip()
 
   mainBody.isBodyActive = false
   mainBody.x = display.contentCenterX
   mainBody.y = display.contentHeight - 100
   timer.resume( "fire" )
   timer.resumeAll( )
 
    -- Fade in the ship
    transition.to( mainBody, { alpha=1, time=4000,
        onComplete = function()
            mainBody.isBodyActive = true
            died = false
            firing = true
            bodyExists = true
            timer.resume( "fire" )
        end
    } )
end

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2

        if ( ( obj1.myName == "shot3" and obj2.myName == "asteroid" ) or
             ( obj1.myName == "asteroid" and obj2.myName == "shot3" ) )
        then

            display.remove( obj1 )
            display.remove( obj2 )
            audio.play(explosionSound)
            for i = #asteroidsTable, 1, -1 do
                if ( asteroidsTable[i] == obj1 or asteroidsTable[i] == obj2 ) then
                    table.remove( asteroidsTable, i )
                    break
                end
            end

            score = score + 100
            scoreText.text = "Score: "..score

         elseif ( ( obj1.myName == "Enemy" and obj2.myName == "asteroid" ) or
                 ( obj1.myName == "asteroid" and obj2.myName == "Enemy" ) )

         then

            display.remove( obj1 )
            display.remove( obj2 )
            audio.play(explosionSound)
            for i = #asteroidsTable, 1, -1 do
                if ( asteroidsTable[i] == obj1 or asteroidsTable[i] == obj2 ) then
                    table.remove( asteroidsTable, i )
                    break
                end
            end
            for i = #enemiesTable, 1, -1 do
                if ( enemiesTable[i] == obj1 or enemiesTable[i] == obj2 ) then
                    table.remove( enemiesTable, i )
                    break
                end
            end

         elseif ( ( obj1.myName == "shot3" and obj2.myName == "Enemy" ) or
             ( obj1.myName == "Enemy" and obj2.myName == "shot3" ) )
        then

            display.remove( obj1 )
            display.remove( obj2 )
            audio.play(explosionSound)
            for i = #enemiesTable, 1, -1 do
                if ( enemiesTable[i] == obj1 or enemiesTable[i] == obj2 ) then
                    table.remove( enemiesTable, i )
                    break
                end
            end

            score = score + 250
            scoreText.text = "Score: "..score

         elseif ( ( obj1.myName == "ship" and obj2.myName == "asteroid" ) or
                 ( obj1.myName == "asteroid" and obj2.myName == "ship" ) or 
                  ( obj1.myName == "ship" and obj2.myName == "Enemy" ) or 
                  ( obj1.myName == "Enemy" and obj2.myName == "ship" ))
        then
            if ( died == false ) then

               died = true 
               audio.play(explosionSound)

               -- update lives
               lives = lives -1
               livesText.text = "Lives: "..lives 

               if (lives == 0) then 
                  display.remove(mainBody)
                  timer.performWithDelay(500, endGame)
                  timer.cancel( "fire" )
                  timer.cancel( "asteroid" )
                  timer.cancel( "enemy" )
                  audio.pause()
                  firing = false
                  bodyExists = false
               else 
                  mainBody.alpha = 0
                  audio.play(explosionSound)
                  timer.performWithDelay( 1000, restoreShip)
                  timer.pause( "fire" )
                  firing = false
                  bodyExists = false
               end
 
            end
 
        end 
    end
end




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



      local spaceBackground = display.newImageRect(background, "background.png", 800, 1400)
      spaceBackground.x = display.contentCenterX
      spaceBackground.y = display.contentCenterY
      spaceBackground.anchorX = 0.5;
      spaceBackground.anchorY = 0.5;
      spaceBackground.xScale = 1.0;
      spaceBackground.yScale = 1.0;
      spaceBackground:toBack( );


      livesText = display.newText(GUI,"Lives: "..lives, 200, 80, native.systemFont, 36)
      scoreText = display.newText(GUI,"Score: "..score, 400, 80, native.systemFont, 36)


      mainBody = display.newImage(main, shipSheet, 2) --77,86);
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

   physics.addBody( mainBody ,"kinematic", {radius = 30 })
 
      mainBody:addEventListener("touch",pickup)
      mainBody.id = 1

 local pauseButton = widget.newButton(
      {
         x = 550,
         y = 20,
         id = "button1",
         label = "PAUSE",
         fontSize = 40,
         onPress = gotoMenu
      }
      )
      
      GUI:insert(pauseButton)
      pauseButton:toFront();

 
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   musicTrack = audio.loadStream( "wave.mp3")
   shootCH = audio.loadSound( "shoot.wav" )
   explosionSound = audio.loadSound("Explosion1.wav")
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

      shootLoopTimer = timer.performWithDelay(350, fireShot3, 0,"fire") --shoots every 300 ms
      gameLoopTimer = timer.performWithDelay( 1000, gameLoop, 0 , "asteroid")
      enemyLoopTimer = timer.performWithDelay(2000, enemyLoop, 0, "enemy")
      Runtime:addEventListener( "collision", onCollision )

   end
end
 
-- "scene:hide()"
function scene:hide( event )
 
   local background = self.view
   local main = self.view
   local GUI = self.view
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.

      -- timer.cancel( LoopTimer)

   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.

      Runtime:removeEventListener( " collision", onCollision)
       physics.pause()
       audio.stop(1)
       composer.removeScene("Game")
       timer.cancelAll( )
       audio.pause()
   end
end
 
-- "scene:destroy()"
function scene:destroy( event )
 
   local background = self.view
   local main = self.view
   local GUI = self.view

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
