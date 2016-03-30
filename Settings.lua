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

function Settings.gamepadpressed(joystick, button)
	if button == "b" then
	    setState(State.title)
    end
end

function Settings.gamepadreleased(joystick, button)
end

function Settings.update(dt)
end

function Settings.draw()
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
	scaleFactor = width/1920
	love.graphics.scale(scaleFactor, scaleFactor)
    love.graphics.print("Settings", width/2, 800)
	love.graphics.setBackgroundColor(0x20,0x20,0x20)
end

return Settings