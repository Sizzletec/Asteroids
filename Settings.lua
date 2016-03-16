Settings = {}
Settings.__index = Settings

gKeyPressed = {}

gCamX,gCamY = 0,0


function Settings.load()
end

function Settings.keyreleased(key)
end


function Settings.keypressed(key, unicode)

	if (key == "escape") then setState(State.title) end
end

function love.gamepadpressed(joystick, button)
end

function Settings.update(dt)
end

function Settings.draw()
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()

	scaleFactor = width/1920

	love.graphics.scale(scaleFactor, scaleFactor)




	fps = love.timer.getFPS()
	love.graphics.setNewFont(60)
    love.graphics.print("Settings", width/2, 800)
	love.graphics.setBackgroundColor(0x20,0x20,0x20)
end

return Settings