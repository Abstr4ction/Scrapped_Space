local composer = require( "composer" )
local scene = composer.newScene()
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here
 
---------------------------------------------------------------------------------
function gotoGame(event)
      composer.removeScene("Game")  --why is this here?
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

local shipOpt = {width=128, height=128, numFrames=2}

local weaponOpt1 = {width=32, height=32, numFrames=5}

local weaponOpt2 = {width=32, height=32, numFrames=6}

local shieldOpt = {width=32, height=32, numFrames=9}

local sawOpt = {width=32, height=32, numFrames=4}

local shipSheet1 = graphics.newImageSheet("HydraShip.png", shipOpt)  --ship 1, hydra
local shipSheet2 = graphics.newImageSheet("MantaShip.png", shipOpt)  --ship 2, manta

local bool shipver = false

-- "scene:create()"
function scene:create( event )
   
   local sceneGroup = self.view
   local contactGroup = display.newGroup()   --group for contact circles
   sceneGroup:insert(contactGroup)
   local mainBody = display.newImage(shipSheet1, 1)   --since this is a guaranteed item in this menu
   sceneGroup:insert(mainBody)                        --it is declared here
   mainBody.anchorX = 0.5;
   mainBody.anchorY = 0.5;
   mainBody.x = display.contentCenterX;
   mainBody.y = display.contentCenterY;
   mainBody.xScale = 2.5;
   mainBody.yScale = 2.5;

   local menuButton = widget.newButton(
   {
   x = display.contentCenterX*(1/2),
   y = display.contentHeight*(15/16),
   id = "button1",
   label = "Return",
   fontSize = 40,
   onEvent = gotoMenu
   }
   )
   local gameButton = widget.newButton(
   {
   x = display.contentCenterX*(3/2),
   y = display.contentHeight*(15/16),
   id = "button2",
   label = "Play!",
   fontSize = 40,
   onEvent = gotoGame
   }
   )
   sceneGroup:insert(menuButton)
   sceneGroup:insert(gameButton)
   function myListener(event)
   end

   function generateAttachCircles(state)
      if(state) then
         attachPoint=display.newCircle(contactGroup, mainBody.x, mainBody.y-30, 7)
         attachPoint:addEventListener( "touch", myListener )
         attachPoint=display.newCircle(contactGroup, mainBody.x+52.5, mainBody.y-80, 7)
         attachPoint:addEventListener( "touch", myListener )
         attachPoint=display.newCircle(contactGroup, mainBody.x-52.5, mainBody.y-80, 7)
         attachPoint:addEventListener( "touch", myListener )
         attachPoint=display.newCircle(contactGroup, mainBody.x+84, mainBody.y+5, 7)
         attachPoint:addEventListener( "touch", myListener )
         attachPoint=display.newCircle(contactGroup, mainBody.x-84, mainBody.y+5, 7)
         attachPoint:addEventListener( "touch", myListener )
         sceneGroup:insert(contactGroup)
      else
         attachPoint=display.newCircle(contactGroup, mainBody.x-101, mainBody.y-20, 7)
         attachPoint:addEventListener( "touch", myListener )
         attachPoint=display.newCircle(contactGroup, mainBody.x+40, mainBody.y-75, 7)
         attachPoint:addEventListener( "touch", myListener )
         attachPoint=display.newCircle(contactGroup, mainBody.x-40, mainBody.y-75, 7)
         attachPoint:addEventListener( "touch", myListener )
         attachPoint=display.newCircle(contactGroup, mainBody.x+101, mainBody.y-20, 7)
         attachPoint:addEventListener( "touch", myListener )
         sceneGroup:insert(contactGroup)
      end
   end

   function ShipSwitch()
   shipver=not shipver
   mainBody:removeSelf()            --clear reference to old image
   mainBody=nil
   contactGroup:removeSelf()
   contactGroup=nil
   contactGroup=display.newGroup()   --group for contact circles
   if(shipver) then
      mainBody = display.newImage(shipSheet2, 1)      --switch to new one
   else
      mainBody = display.newImage(shipSheet1, 1)
   end
   sceneGroup:insert(mainBody)
   mainBody.anchorX = 0.5;
   mainBody.anchorY = 0.5;
   mainBody.x = display.contentCenterX;
   mainBody.y = display.contentCenterY;
   mainBody.xScale = 2.5;
   mainBody.yScale = 2.5;
   generateAttachCircles(not shipver)
   end

   local switchButton = widget.newButton(
   {
   x = display.contentCenterX,
   y = display.contentHeight*(1/16),
   id = "button2",
   label = "switch ship",
   fontSize = 40,
   onPress = ShipSwitch
   }
   )
   sceneGroup:insert(switchButton)

   generateAttachCircles(not shipver)  --executes once to generate attach circles
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
