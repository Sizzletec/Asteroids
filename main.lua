gKeyPressed = {}

function love.load()
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
end
function love.draw()
    love.graphics.print('Astroids', 50, 50)
	love.graphics.setBackgroundColor(0x80,0x80,0x80)
end