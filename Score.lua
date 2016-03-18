Score = {}
Score.__index = Score


gKeyPressed = {}

local winner

function Score.load()
end


function Score.keyreleased(key)
	gKeyPressed[key] = nil
end


function Score.keypressed(key, unicode)
	gKeyPressed[key] = true
	if (key == "escape") then setState(State.title) end
	if (key == "return") then 
		for i, player in pairs(selections) do
			ship = player.ship

			if ship then
				ship:setDefaults()
			end
		end
		setState(State.shipSelect) 

	end
end

function Score.gamepadpressed(joystick, button)
end

function Score.gamepadreleased(joystick, button)
end

function Score.update(dt)
end

function Score.draw()
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()

	scaleFactor = width/1920

	love.graphics.scale(scaleFactor, scaleFactor)

	love.graphics.setBackgroundColor(0x20,0x20,0x20)
	love.graphics.setColor(255, 255, 255)
	love.graphics.setNewFont(60)

	love.graphics.print("Scores for that game you just played", 100, 100)


	for i, player in pairs(selections) do
		ship = player.ship

		if ship then
			love.graphics.print("Longest Dead".. ship.explodingFrame , 100, 200 + 50*i)

		end

	end

	-- love.graphics.print("Winner: Player ".. winner , 100, 200)
end




return Score