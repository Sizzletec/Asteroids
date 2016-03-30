Score = {}
Score.__index = Score


gKeyPressed = {}

placeStrings = {
	"Winner!!",
	"Second..",
	"Not Last!?",
	"...hmm"
} 

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
		end
		setState(State.shipSelect) 
	end
end

function Score.gamepadpressed(joystick, button)
	 if button == "start" then
    	for i, player in pairs(selections) do
			ship = player.ship
		end
		setState(State.shipSelect) 
    end
end

function Score.gamepadreleased(joystick, button)
end

function Score.gamepadaxis(joystick, axis, value)
end

function Score.update(dt)
end

function Score.draw()
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()

	scaleFactor = width/1920
	love.graphics.scale(scaleFactor, scaleFactor)
	love.graphics.setBackgroundColor(0x20,0x20,0x20)

	for i, player in pairs(selections) do
		love.graphics.setColor(255, 255, 255)
		love.graphics.setNewFont(60)
		ship = player.ship

		if ship then
			local xOffset = 1920/4 * (i-1) + 100

			love.graphics.print("Player " .. ship.player, xOffset, 100)
			love.graphics.print(placeStrings[ship.place], xOffset, 200)

			love.graphics.setColor(200, 200, 200)
			love.graphics.setNewFont(30)

			love.graphics.print("Kills\n" .. ship.kills, xOffset, 330)
			love.graphics.print("Deaths\n" .. ship.deaths, xOffset, 410 )
			love.graphics.print("Shots\n" .. ship.shots, xOffset, 490 )
			love.graphics.print("Hits\n" .. ship.hits, xOffset, 570 )
			love.graphics.print("Damage Given\n" .. ship.damageGiven, xOffset, 650 )
			love.graphics.print("Damage Taken\n" .. ship.damageTaken, xOffset, 730 )
			love.graphics.print("Walls Hit\n" .. ship.wallsRunInto, xOffset, 810 )
		end
	end

	love.graphics.setColor(255, 255, 255)
	love.graphics.setNewFont(60)
	love.graphics.print("Press start to stop looking at this.",500, 960)
end

return Score