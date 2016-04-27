Title = {}
Title.__index = Title

love.filesystem.load("maps/tiledmap.lua")()

local highlightedOption = 1
local menuOptions = {
	"Local Multiplayer",
	"Settings"
}
gKeyPressed = {}
gCamX,gCamY = 0,0

local menuSpeed = 0.3
local menuCooldown = 0

function Title.load()
	TiledMap_Load("maps/title.tmx",16)
end

function Title.keyreleased(key)
	gKeyPressed[key] = nil
end

function Title.keypressed(key, unicode)
	gKeyPressed[key] = true
	if (key == "escape") then love.event.quit() end
	if (key == "up") then Title.menuUp() end
	if (key == "down") then Title.menuDown() end
	if (key == "return") then
		Title.SelectMenuItem()
	end
end

function Title.SelectMenuItem()
	if highlightedOption == 1 then
		setState(State.shipSelect)
	elseif highlightedOption == 2 then
		setState(State.settings)
	end
end

function Title.gamepadpressed(joystick, button)
    if button == "a" then
    	Title.SelectMenuItem()
    end
end

function Title.gamepadreleased(joystick, button)
    if button == "a" then
    end
end

function Title.gamepadaxis(joystick, axis, value)
	if menuCooldown <= 0 and axis ==  "lefty" then
		if value > 0.7 then
			Title.menuDown()
		elseif value < -0.7 then
			Title.menuUp()
		end
	end
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
	end
end

function Title.draw()
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()

	scaleFactor = width/1920

	love.graphics.scale(scaleFactor, scaleFactor)

	gCamX,gCamY = width/2,height/2
	love.graphics.setColor(255, 255, 255)
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
    love.graphics.print(menuString, 1200, 850)
	love.graphics.setBackgroundColor(0x20,0x20,0x20)
end

return Title