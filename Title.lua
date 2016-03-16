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

local menuSpeed = 0.3
local menuCooldown = 0 

function Title.load()
	
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

function Title.gamepadpressed(joystick, button)
    if button == "a" then
    	setState(highlightedOption)
    end
end

function Title.gamepadreleased(joystick, button)
    if button == "a" then
    end
end

function Title.gamepadaxis(joystick, axis, value)

end

function Title.menuUp()
	highlightedOption = highlightedOption - 1
	if highlightedOption == 0 then
		highlightedOption = table.getn(menuOptions)
	end
	menuCooldown = menuSpeed
end

function Title.menuDown()
	highlightedOption = highlightedOption + 1
	if highlightedOption > table.getn(menuOptions) then
		highlightedOption = 1
	end
	menuCooldown = menuSpeed
end

function Title.update(dt)
	if menuCooldown > 0 then
		menuCooldown = menuCooldown - dt
	else
		local joysticks = love.joystick.getJoysticks()
		joy = joysticks[1]

		if joy then
			joyY = joy:getGamepadAxis("lefty")

			if joyY > 0.7 then
				Title.menuDown()
			elseif joyY < -0.7 then
				Title.menuUp()
			elseif joyY < 0.7 and joyY > -0.7 then
				menuCooldown = 0
			end 

		end
	end

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

	love.graphics.setNewFont(60)
    love.graphics.print(menuString, width/2, 800)
	love.graphics.setBackgroundColor(0x20,0x20,0x20)
end

function love.quit()
end

return Title