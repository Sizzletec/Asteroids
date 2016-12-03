menuSound = love.audio.newSource("sounds/select.wav", "static")

require('helpers/PointWithinShape')
require('scene/Game')
require('scene/Title')
require('scene/Settings')
require('scene/ShipSelect')
require('scene/Score')

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
	love.window.setMode(1920/2, 1080/2, {fullscreen=false, resizable=true, highdpi=true})
	setState(ShipSelect)

	-- love.mouse.setVisible(false)
end

-- function love.resize(w, h)
--   print(("Window resized to width: %d and height: %d."):format(love.window.fromPixels(w, h)))

--   sixteen = love.window.fromPixels(w) % 16
--   if sixteen ~= 0 then
--   	w =  love.window.fromPixels(w) - sixteen
--   	print("width is not even")

--   	width, height, flags = love.window.getMode( )
--   	love.window.setMode(w, love.window.fromPixels(h), {fullscreen=false, resizable=true, highdpi=true})
--   end
-- end

function love.resize(w, h)
  	if currentState.resize then
		currentState.resize(w, h)
	end
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

	-- canvas = love.graphics.newCanvas( 600, 600 )
	-- love.graphics.setCanvas(canvas)
	-- love.graphics.clear()

	if currentState.draw then
		currentState.draw()
	end
	-- love.graphics.setCanvas()
	-- if (Game.getPlayers()[1]) then
	-- 	m = Game.getPlayers()[1].components.move
	-- 	love.graphics.draw(canvas, m.x -50, m.y -50)
	-- end	
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