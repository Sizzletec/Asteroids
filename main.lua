local Game = require('Game')
local Title = require('Title')
local Settings = require('Settings')
local ShipSelect = require('ShipSelect')
local Score = require('Score')

require('PointWithinShape')

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
	currentState.keyreleased(key)
end

function love.keypressed(key, unicode)
	gKeyPressed[key] = true
	currentState.keypressed(key,unicode)
end

function love.gamepadpressed(joystick, button)
	currentState.gamepadpressed(joystick, button)
end

function love.gamepadreleased(joystick, button)
	currentState.gamepadreleased(joystick, button)
end

function love.gamepadaxis(joystick, axis, value)
	currentState.gamepadaxis(joystick, axis, value)
end

function love.update( dt )
	currentState.update(dt)
	collectgarbage()
end

function love.draw()
	currentState.draw()
end

function setState(newState)
	currentState = newState
	currentState.load()
end

function love.quit()
end