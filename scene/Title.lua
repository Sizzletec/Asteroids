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

local menuSpeed = 0.2
local menuCooldown = 0

function Title.load()
	TiledMap_Load("maps/title.tmx",16)
end

function Title.SelectMenuItem()
	if highlightedOption == 1 then
		setState(State.shipSelect)
	elseif highlightedOption == 2 then
		setState(State.settings)
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
	if love.keyboard.isDown("escape") then love.event.quit() end
	for _,player in pairs(Players) do
		if menuCooldown > 0 then
			menuCooldown = menuCooldown - dt
		else
			Title.getPlayerInput(player)
		end
	end
end

function Title.getPlayerInput(player)
	if player.input == "joystick" then
		if love.joystick.isDown(player.joystick, "a") then
			Title.SelectMenuItem()
		else
			value = love.joystick.getAxis(player.joystick, "lefty")
			if value > 0.7 then
				Title.menuDown()
			elseif value < -0.7 then
				Title.menuUp()
			end
		end
	elseif player.input == "keyboard" then
		if love.keyboard.isDown("return") then
			Title.SelectMenuItem()
		elseif love.keyboard.isDown("up") then
			Title.menuUp()
		elseif love.keyboard.isDown("down") then
			Title.menuDown()
		end
	end 
end

function Title.draw()
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()

	scaleFactor = width/1920

	love.graphics.scale(scaleFactor, scaleFactor)

	love.graphics.setColor(255, 255, 255)

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