local composer = require( "composer" )
local scene = composer.newScene()
 
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here
 
---------------------------------------------------------------------------------
 function gotoMenu(event)
      composer.gotoScene("Menu", 
     {
         effect = "slideUp",
         time = 100,
      })
end

local json = require("json")
local scoresTable = {}

local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory)

local function loadScores()
      local file = io.open (  filePath, "r")

      if file then
            local contents = file:read("*a")
            io.close( file)
            scoresTable = json.decode( contents)
      end
      if scoresTable == nil or #scoresTable == 0 then 
            scoresTable = {0,0,0,0,0,0,0,0}
      end
end

local function saveScores()

   for i = #scoresTable, 11, -1 do 
      table.remove(scoresTable, i)
   end 

   local file = io.open(filePath, "w")

   local temp = json.encode(scoresTable)

   file:write( temp)
   io.close(file)
end

-- "scene:create()"
function scene:create( event )
 
   local sceneGroup = self.view

   loadScores()

   table.insert( scoresTable, composer.getVariable("finalScore"))

   local function compare (a, b)
      return a > b
   end
   table.sort(scoresTable, compare)

   saveScores()

   local background = display.newImageRect( sceneGroup, "background.png", 800, 1400)
      background.x = display.contentCenterX
      background.y = display.contentCenterY
      background.anchorX = 0.5;
      background.anchorY = 0.5;
      background.xScale = 1.0;
      background.yScale = 1.0;
      background:toBack( );

      local highScoreHeader = display.newText(sceneGroup, "High Scores ", display.contentCenterX, 100, nil, 44)

      for i = 1, 10 do 

         if (scoresTable[i]) then 
            local yPos = 150 + (i * 56)

            local rankNum = display.newText(sceneGroup, i ..") ", display.contentCenterX-50, yPos, nil, 35)
            rankNum:setFillColor (0.8)
            rankNum.anchorX = 1

            local thisScore = display.newText(sceneGroup, scoresTable[i], display.contentCenterX-30, yPos, nil,35) 
            thisScore.anchorX = 0
         end
      end


       local returnButton = widget.newButton(
      {
         x = display.contentCenterX*(1/2),
         y = display.contentHeight*(15/16),
         id = "button1",
         label = "Return",
         fontSize = 40,
         onEvent = gotoMenu
      }
      )
      sceneGroup:insert(returnButton);

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