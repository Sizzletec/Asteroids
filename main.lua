local Game = require('Game')
local Title = require('Title')
local Settings = require('Settings')
local ShipSelect = require('ShipSelect')

State = {
	title = 0,
	onlineMulti = 1,
	shipSelect = 2,
	settings = 3,
	game = 4
}

currentState = State.game

function love.load()
	setState(currentState)
end

function love.keyreleased(key)
	if currentState == State.game then
		Game.keyreleased(key)
	elseif currentState == State.title then
		Title.keyreleased(key)
	elseif currentState == State.settings then
		Settings.keyreleased(key)
	elseif currentState == State.shipSelect then
		ShipSelect.keyreleased(key)
	end
end


function love.keypressed(key, unicode)
	gKeyPressed[key] = true
	if currentState == State.game then
		Game.keypressed(key,unicode)
	elseif currentState == State.title then
		Title.keypressed(key,unicode)
	elseif currentState == State.settings then
		Settings.keypressed(key,unicode)
	elseif currentState == State.shipSelect then
		ShipSelect.keypressed(key,unicode)
	end
end

function love.gamepadpressed(joystick, button)
    if currentState == State.game then
		Game.gamepadpressed(joystick, button)
	elseif currentState == State.title then
		Title.gamepadpressed(joystick, button)
	elseif currentState == State.settings then
		Settings.gamepadpressed(joystick, button)
	elseif currentState == State.shipSelect then
		ShipSelect.gamepadpressed(joystick, button)
	end
end

function love.update( dt )
	if currentState == State.game then
		Game.update(dt)
	elseif currentState == State.title then
		Title.update(dt)
	elseif currentState == State.settings then
		Settings.update()
	elseif currentState == State.shipSelect then
		ShipSelect.update()
	end
end

function love.draw()
	if currentState == State.game then
		Game.draw()
	elseif currentState == State.title then
		Title.draw()
	elseif currentState == State.settings then
		Settings.draw()
	elseif currentState == State.shipSelect then
		ShipSelect.draw()
	end
end

function setState(newState)
	currentState = newState
	if currentState == State.game then
		Game.load()
	elseif currentState == State.title then
		Title.load()
	elseif currentState == State.settings then
		Settings.load()
	elseif currentState == State.shipSelect then
		ShipSelect.load()
	end
end

function love.quit()
end