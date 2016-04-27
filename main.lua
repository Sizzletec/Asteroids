require('helpers/PointWithinShape')

local Game = require('scene/Game')
local Title = require('scene/Title')
local Settings = require('scene/Settings')
local ShipSelect = require('scene/ShipSelect')
local Score = require('scene/Score')

State = {
	title = Title,
	onlineMulti = ShipSelect,
	shipSelect = ShipSelect,
	settings = Settings,
	game = Game,
	score = Score
}

currentState = State.title

function love.load()
	love.window.setMode(1920, 1080, {fullscreen=false, resizable=true, highdpi=true})
	setState(currentState)
	-- love.mouse.setVisible(false)
end

function love.keyreleased(key)
	if currentState.keyreleased then
		currentState.keyreleased(key)
	end
end

function love.keypressed(key, unicode)
	if currentState.keypressed then
		currentState.keypressed(key,unicode)
	end
end

function love.gamepadpressed(joystick, button)
	if currentState.gamepadpressed then
		currentState.gamepadpressed(joystick, button)
	end
end

function love.gamepadreleased(joystick, button)
	if currentState.gamepadreleased then
		currentState.gamepadreleased(joystick, button)
	end
end

function love.gamepadaxis(joystick, axis, value)
	if currentState.gamepadaxis then
		currentState.gamepadaxis(joystick, axis, value)
	end
end

function love.update( dt )
	if currentState.update then
		currentState.update(dt)
	end
	collectgarbage()
end

function love.draw()
	-- currentState.draw = function()
	-- 	 love.graphics.print("NOPE!!", 1200, 850)
	-- end

	if currentState.draw then
		currentState.draw()
	end
end

function setState(newState)
	currentState = newState
	if currentState.load then
		currentState.load()
	end
end

function love.quit()
	if currentState.quit then
		currentState.quit()
	end
end