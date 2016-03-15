ShipSelect = {}
ShipSelect.__index = ShipSelect


gKeyPressed = {}

local Ship = require('Ship')

function ShipSelect.load()
end

function ShipSelect.keyreleased(key)
	gKeyPressed[key] = nil
end


function ShipSelect.keypressed(key, unicode)
	gKeyPressed[key] = true
	if (key == "return") then setState(State.game) end

end

function love.gamepadpressed(joystick, button)
    if button == "a" then
    	-- id, instanceid = joystick:getID()
    	-- localPlayer:fire()
    end
end

function ShipSelect.update(dt)
	local joysticks = love.joystick.getJoysticks()
	joy = joysticks[1]
	if joy then
		joyX = joy:getGamepadAxis("leftx")
		joyCannonX = joy:getGamepadAxis("rightx")
		joyCannonY = joy:getGamepadAxis("righty")
		throttle = joy:getGamepadAxis("triggerright")
	end
end

function ShipSelect.draw()
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()

	scaleFactor = width/1920

	love.graphics.scale(scaleFactor, scaleFactor)


	fps = love.timer.getFPS()
	love.graphics.setNewFont(60)
    love.graphics.print("hello", width/2, 800)
	love.graphics.setBackgroundColor(0x20,0x20,0x20)
end

return ShipSelect