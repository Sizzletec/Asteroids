local Ship = require('Ship')
gKeyPressed = {}

function love.load()
	ship1 = Ship.new(100,200,0.3,0.02)
	ship2 = Ship.new(130,300,0.1,0.1)
end

function love.keyreleased(key)
	gKeyPressed[key] = nil
end

function love.keypressed(key, unicode)
	gKeyPressed[key] = true
	if (key == "escape") then os.exit(0) end
end

function love.update( dt )
	local s = 0
	if (gKeyPressed.up) then
		s = 10
	end
	ship1:update()
	ship2:update()
end
function love.draw()
	ship1:draw()
	ship2:draw()
    love.graphics.print('Astroids', 50, 50)
	love.graphics.setBackgroundColor(0x80,0x80,0x80)
end