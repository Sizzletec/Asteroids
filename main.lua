local Game = require('Game')
local Title = require('Title')
local Settings = require('Settings')

State = {
	title = 0,
	onlineMulti = 1,
	game = 2,
	settings = 3
}

currentState = State.title

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
	end
end

function love.update( dt )
	if currentState == State.game then
		Game.update(dt)
	elseif currentState == State.title then
		Title.update(dt)
	elseif currentState == State.settings then
		Settings.update()
	end
end

function love.draw()
	if currentState == State.game then
		Game.draw()
	elseif currentState == State.title then
		Title.draw()
	elseif currentState == State.settings then
		Settings.draw()
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
	end
end

function love.quit()
end