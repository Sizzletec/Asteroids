Title = {}
Title.__index = Title

love.filesystem.load("tiledmap.lua")()
local Ship = require('Ship')
local Bullet = require('Bullet')

local highlightedOption = 1
local menuOptions = {
	"Online Multiplayer",
	"Local Multiplayer",
	"Settings"
}
gKeyPressed = {}
gCamX,gCamY = 0,0


function Title.load()
	love.window.setMode(1920/2, 1080/2, {fullscreen=false, resizable=true, highdpi=true})
	scale = love.window.getPixelScale()

	TiledMap_Load("title.tmx",16)
end

function Title.keyreleased(key)
	gKeyPressed[key] = nil
end

function Title.keypressed(key, unicode)
	gKeyPressed[key] = true
	if (key == "escape") then love.event.quit() end
	if (key == "up") then Title.menuUp() end
	if (key == "down") then Title.menuDown() end
	if (key == "return") then setState(highlightedOption) end
end

function Title.menuUp()
	highlightedOption = highlightedOption - 1
	if highlightedOption == 0 then
		highlightedOption = table.getn(menuOptions)
	end
end

function Title.menuDown()
	highlightedOption = highlightedOption + 1
	if highlightedOption > table.getn(menuOptions) then
		highlightedOption = 1
	end
end

function love.gamepadpressed(joystick, button)
    if button == "a" then
    	id, instanceid = joystick:getID()
    	localPlayer:fire()
    end
end

function Title.update(dt)
end

function Title.draw()
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()

	scaleFactor = width/1920

	love.graphics.scale(scaleFactor, scaleFactor)

	gCamX,gCamY = width/2,height/2
	TiledMap_AllAtCam(gCamX,gCamY)

	local menuString = ""
	for i, option in ipairs(menuOptions) do
		if highlightedOption == i then
			menuString = menuString .. "> "
		else
			menuString = menuString .. "  "
		end
		menuString = menuString .. option .. "\n"
	end

	fps = love.timer.getFPS()
	love.graphics.setNewFont(60)
    love.graphics.print(menuString, width/2, 800)
	love.graphics.setBackgroundColor(0x20,0x20,0x20)
end

function love.quit()
end

return Title