local composer = require( "composer" )
local scene = composer.newScene()
local set=0;
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

function pickup(event)
   if(event.phase=="began") then
      set=event.target.id
   elseif(event.phase=="moved") then
      event.target.x=event.x
      event.target.y=event.y
   else
      event.target.x=event.target.xtest;
      event.target.y=event.target.ytest;
   end
   return true
end

local shipOpt = {width=128, height=128, numFrames=2}

local weaponOpt1 = {width=32, height=32, numFrames=5}

local weaponOpt2 = {width=32, height=32, numFrames=6}

local shieldOpt = {width=32, height=32, numFrames=9}

local sawOpt = {width=32, height=32, numFrames=4}

local shipSheet1 = graphics.newImageSheet("HydraShip.png", shipOpt)  --ship 1, hydra
local shipSheet2 = graphics.newImageSheet("MantaShip.png", shipOpt)  --ship 2, manta

local weaponSheet1 = graphics.newImageSheet("Cannon1.png", weaponOpt1)  
local weaponSheet2 = graphics.newImageSheet("Cannon2.png", weaponOpt2)  
local shieldSheet = graphics.newImageSheet("Shield.png", shieldOpt)  
local sawSheet = graphics.newImageSheet("Sawblade.png", sawOpt)

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

   --creation of items begins here
   local peashooter = display.newImage(weaponSheet1, 1)   --since this is a guaranteed item in this menu
   sceneGroup:insert(peashooter)                        --it is declared here
   peashooter.anchorX = 0.5;
   peashooter.anchorY = 0.5;
   peashooter.x = display.contentCenterX-100;
   peashooter.y = display.contentCenterY-200;
   peashooter.xScale = 2.5;
   peashooter.yScale = 2.5;
   peashooter.xtest=peashooter.x;
   peashooter.ytest=peashooter.y;
   peashooter:addEventListener("touch",pickup)
   peashooter.id=1

   local railCannon = display.newImage(weaponSheet2, 1)   --since this is a guaranteed item in this menu
   sceneGroup:insert(railCannon)                        --it is declared here
   railCannon.anchorX = 0.5;
   railCannon.anchorY = 0.5;
   railCannon.x = display.contentCenterX-200;
   railCannon.y = display.contentCenterY-200;
   railCannon.xScale = 2.5;
   railCannon.yScale = 2.5;
   railCannon.xtest=railCannon.x;
   railCannon.ytest=railCannon.y;
   railCannon:addEventListener("touch",pickup)
   railCannon.id=2
   
   local shield = display.newImage(shieldSheet, 1)   --since this is a guaranteed item in this menu
   sceneGroup:insert(shield)                        --it is declared here
   shield.anchorX = 0.5;
   shield.anchorY = 0.5;
   shield.x = display.contentCenterX;
   shield.y = display.contentCenterY-200;
   shield.xScale = 2.5;
   shield.yScale = 2.5;
   shield.xtest=shield.x;
   shield.ytest=shield.y;
   shield:addEventListener("touch",pickup)
   shield.id=3
   
   local saw = display.newImage(sawSheet, 1)   --since this is a guaranteed item in this menu
   sceneGroup:insert(saw)                        --it is declared here
   saw.anchorX = 0.5;
   saw.anchorY = 0.5;
   saw.x = display.contentCenterX+100;
   saw.y = display.contentCenterY-200;
   saw.xScale = 2.5;
   saw.yScale = 2.5;
   saw.xtest=saw.x;
   saw.ytest=saw.y;
   saw:addEventListener("touch",pickup)
   saw.id=4
   
   --creation of items ends here

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

   function myListener(event) --event for drag n drop
      local x=event.target.x
      local y=event.target.y
      if(set==0)then
      elseif(set==1)then
         event.target:removeSelf()
         event.target=nil
         event.target = display.newImage(weaponSheet1, 1)   --since this is a guaranteed item in this men                     
         event.target.anchorX = 0.5;
         event.target.anchorY = 0.5;
         event.target.x = x;
         event.target.y = y;
         event.target.xScale = 2.5;
         event.target.yScale = 2.5;
         event.target.id=1;
         contactGroup:insert(event.target)
         sceneGroup:insert(contactGroup)
         event.target:addEventListener("touch",myListener)
      elseif(set==2)then
         event.target:removeSelf()
         event.target=nil
         event.target = display.newImage(weaponSheet2, 1)   --since this is a guaranteed item in this menu
         sceneGroup:insert(event.target)                        
         event.target.anchorX = 0.5;
         event.target.anchorY = 0.5;
         event.target.x = x;
         event.target.y = y;
         event.target.xScale = 2.5;
         event.target.yScale = 2.5;
         event.target.id=2;
         contactGroup:insert(event.target)
         sceneGroup:insert(contactGroup)
         event.target:addEventListener("touch",myListener)
      elseif(set==3)then
         event.target:removeSelf()
         event.target=nil
         event.target = display.newImage(shieldSheet, 1)   --since this is a guaranteed item in this menu
         sceneGroup:insert(event.target)                      
         event.target.anchorX = 0.5;
         event.target.anchorY = 0.5;
         event.target.x = x;
         event.target.y = y;
         event.target.xScale = 2.5;
         event.target.yScale = 2.5;
         event.target.id=3;
         contactGroup:insert(event.target)
         sceneGroup:insert(contactGroup)
         event.target:addEventListener("touch",myListener)
      elseif(set==4)then
         event.target:removeSelf()
         event.target=nil
         event.target = display.newImage(sawSheet, 1)   --since this is a guaranteed item in this menu
         sceneGroup:insert(event.target)                       
         event.target.anchorX = 0.5;
         event.target.anchorY = 0.5;
         event.target.x = x;
         event.target.y = y;
         event.target.xScale = 2.5;
         event.target.yScale = 2.5;
         event.target.id=4;
         contactGroup:insert(event.target)
         sceneGroup:insert(contactGroup)
         event.target:addEventListener("touch",myListener)
      else
      end
   end

   function generateAttachCircles(state)     --setup for the attach circles
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
   mainBody:toBack();
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
   print(sceneGroup);
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
