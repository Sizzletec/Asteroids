menuSound = love.audio.newSource("sounds/select.wav", "static")

require('helpers/PointWithinShape')
require('scene/Game')
require('scene/Title')
require('scene/Settings')
require('scene/ShipSelect')
require('scene/Score')
require('object/Player')

Players = {}

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
	-- setState(ShipSelect)
	love.graphics.setDefaultFilter( 'nearest', 'nearest' )

	for x=1,4 do
		table.insert(Players,Player.new())
	end
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
	Players[1].input = "keyboard"
end

function love.keypressed(key, unicode)
	Players[1].input = "keyboard"

	if currentState.keypressed then
		currentState.keypressed(key, unicode)
	end
end

function love.gamepadpressed(joystick, button)
	Players[joystick:getID()].input = "joystick"

	for _,player in pairs(Players) do
		if player.joystick == joystick then
			player.input = "joystick"
		end  
	end

	if currentState.gamepadpressed then
		currentState.gamepadpressed(joystick, button)
	end
end

function love.gamepadreleased(joystick, button)
	for _,player in pairs(Players) do
		if player.joystick == joystick then
			player.input = "joystick"
		end  
	end
end

function love.gamepadaxis(joystick, axis, value)
	for _,player in pairs(Players) do
		if player.joystick == joystick then
			player.input = "joystick"
		end  
	end

	if currentState.gamepadaxis then
		currentState.gamepadaxis(joystick, axis, value)
	end
end

function love.joystickadded(joystick)
	-- print(joystick:getName(), joystick:getGUID( ),joystick:getID( ), "added")
	Players[joystick:getID()].input = "joystick"
	Players[joystick:getID()].joystick = joystick
end

function love.joystickremoved( joystick )
	-- print(joystick:getName(), joystick:getGUID( ),joystick:getID( ),"remove")
	Players[joystick:getID()].input = ""
	Players[joystick:getID()].joystick = nil
end

function love.update( dt )
	if currentState.update then
		currentState.update(dt)
	end
	collectgarbage()
end

function love.draw()
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