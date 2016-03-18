ShipSelect = {}
ShipSelect.__index = ShipSelect


gKeyPressed = {}

local Ship = require('Ship')
local Bullet = require('Bullet')
local t = 0

SelectStep = {
	inactive = 0,
	active = 1,
	ready = 2
}

local menuSpeed = 0.3

selections = {
 	{
		step = SelectStep.inactive,
		menuCooldown = 0
	},
	{
		step = SelectStep.inactive,
		menuCooldown = 0
	},
	{
		step = SelectStep.inactive,
		menuCooldown = 0
	},
	{
		step = SelectStep.inactive,
		menuCooldown = 0
	}
}

function ShipSelect.load()
	-- selections[1].step = SelectStep.active
	-- selections[1].ship = Ship.new(1,0,0)
	-- selections[1].ship.color = 0

	-- selections[2].step = SelectStep.active
	-- selections[2].ship = Ship.new(2,0,0)
	-- selections[2].ship.color = 1

	-- selections[3].step = SelectStep.active
	-- selections[3].ship = Ship.new(3,0,0)
	-- selections[3].ship.color = 2

	-- selections[4].step = SelectStep.active
	-- selections[4].ship = Ship.new(4,0,0)
	-- selections[4].ship.color = 3
end

function ShipSelect.activate(player)
	selections[player].step = SelectStep.active
	selections[player].ship = Ship.new(player,0,0)
	selections[player].ship.color = player - 1
end

function ShipSelect.makeInactive(player)
	selections[player].step = SelectStep.inactive
	selections[player].ship = nil
end

function ShipSelect.unReady(player)
	selections[player].step = SelectStep.active
end

function ShipSelect.makeReady(player)
	selections[player].step = SelectStep.ready
end

function ShipSelect.keyreleased(key)
	gKeyPressed[key] = nil
end


function ShipSelect.keypressed(key, unicode)
	gKeyPressed[key] = true
	if (key == "escape") then setState(State.title) end
	if (key == "return") then setState(State.game) end
	if (key == "space") then
		ship = selections[1].ship

		ship.color = ship.color + 1
		if ship.color > 3 then
			ship.color = 0
		end
	end
    if (key == "left") then
    	ShipSelect.shipLeft(1)
	end
	if (key == "right") then
		ShipSelect.shipRight(1)

	end
end

function ShipSelect.shipLeft(id)
	local ship = selections[id].ship
	if ship then
		if ship.shipType == ShipType.standard then
			selections[id].ship.shipType = ShipType.gunship
		elseif ship.shipType == ShipType.gunship then
			selections[id].ship.shipType = ShipType.assalt
		else
			selections[id].ship.shipType = ShipType.standard
		end
	end
end



function ShipSelect.shipRight(id)
	local ship = selections[id].ship
	if ship then
		if ship.shipType == ShipType.standard then
			selections[id].ship.shipType = ShipType.assalt
		elseif ship.shipType == ShipType.assalt then
			selections[id].ship.shipType = ShipType.gunship
		else
			selections[id].ship.shipType = ShipType.standard
		end
	end
end


function ShipSelect.gamepadpressed(joystick, button)
	local id, instanceid = joystick:getID()
	local player = selections[id]

	if player.step == SelectStep.inactive then
		if button == "a" then
			ShipSelect.activate(id)
    	end
    	if button == "b" then
	    	setState(State.title)
    	end
	elseif player.step == SelectStep.active then
		if button == "x" or button == "y" then
	    	ship = player.ship

	    	if ship then
				ship.color = ship.color + 1
				if ship.color > 3 then
					ship.color = 0
				end
			end
	    end

	    if button == "a" then
	    	ShipSelect.makeReady(id)
    	end

    	if button == "b" then
	    	ShipSelect.makeInactive(id)
    	end
    elseif player.step == SelectStep.ready then
    	if button == "b" then
	    	ShipSelect.unReady(id)
    	end
	end

    if button == "start" then
    	setState(State.game)
    end

end


function ShipSelect.gamepadaxis(joystick, axis, value)
	local id, instanceid = joystick:getID()
	local player = selections[id]

	if axis ==  "leftx"
		and player.menuCooldown <= 0
		and player.step == SelectStep.active then

		if value > 0.7 then
			ShipSelect.shipRight(id)
			player.menuCooldown = menuSpeed
		elseif value < -0.7 then
			ShipSelect.shipLeft(id)
			player.menuCooldown = menuSpeed
		end 
	end

end

function ShipSelect.gamepadreleased(joystick, button)
    if button == "a" then
    end
end

function ShipSelect.update(dt)
	local joysticks = love.joystick.getJoysticks()
	joy = joysticks[1]
	if joy then
		joyX = joy:getGamepadAxis("leftx")
		joyCannonX = joy:getGamepadAxis("rightx")
		joyCannonY = joy:getGamepadAxis("righty")
		throttle = joy:getGamepadAxis("triggerright")
	end

	t = t + dt

	for i, player in pairs(selections) do
		if player.menuCooldown > 0 then
		player.menuCooldown = player.menuCooldown - dt
		end
		

		if player.step == SelectStep.active then
			ShipSelect.updateActive(i, player, dt)
		elseif player.step == SelectStep.ready then
			ShipSelect.updateReady(i, player, dt)
		end

	end

	if t > 4 then
		t = t - 4
	end
end

function ShipSelect.draw()
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()

	scaleFactor = width/1920

	love.graphics.scale(scaleFactor, scaleFactor)


	for i, player in pairs(selections) do

		if player.step == SelectStep.active then
			ShipSelect.drawActive(i, player)

		elseif player.step == SelectStep.inactive then
			ShipSelect.drawInactive(i, player)
		elseif player.step == SelectStep.ready then
			ShipSelect.drawReady(i, player)
		end
		
	end

	-- for i, player in pairs(selections) do
	-- 	bullets = table.getn(player.ship.bullets)
	-- 	love.graphics.print(bullets, 50, 100*i+30)
	-- end
	love.graphics.push()
	love.graphics.scale(2,2)
	Bullet.draw()
	love.graphics.pop()

	love.graphics.setBackgroundColor(0x20,0x20,0x20)
end

function ShipSelect.updateActive(i, player, dt)
	if t > 3 then
		player.ship.engine = true
	elseif t > 2 then
		player.ship.firing = true
	else
		player.ship.engine = false 
		player.ship.firing = false
	end

	if not player.ship.engine then
		player.ship.rotation = player.ship.rotation + 2 * dt
	end
	player.ship:update(dt)
end


function ShipSelect.updateReady(i, player, dt)
	player.ship.engine = false 
	player.ship.firing = false

	if not player.ship.engine then
		player.ship.rotation = player.ship.rotation + -1 * dt
	end
	player.ship:update(dt)
end


function ShipSelect.drawActive(i, player)
	love.graphics.setColor(255, 255, 255)
	love.graphics.setNewFont(60)
	local playerShip = player.ship
	local xOffset = 1920/4 * (i-1) + 100
	local yOffset = 1080/8
	love.graphics.print("Player " .. i, xOffset+30, yOffset)

	local playerColor = player.ship.color



	local yOffset = 1080/8 + 400
	love.graphics.setColor(255, 255, 255)
	love.graphics.polygon("fill", xOffset-30, yOffset+30, xOffset-30, yOffset-30, xOffset-60, yOffset)

	local triOffset = 1920/4 * i - 40
	love.graphics.polygon("fill", triOffset-30, yOffset+30, triOffset-30, yOffset-30, triOffset, yOffset)

	love.graphics.push()
	love.graphics.scale(2,2)
	local playerShip = player.ship
	if playerShip then
		playerShip.x = (xOffset+120)/2
		playerShip.y = (yOffset-150)/2
		playerShip:draw()
	end
	love.graphics.pop()

	local playerType = player.ship.shipType
	love.graphics.print(playerType.name, xOffset, yOffset - 45)


		local colorName = "Gray"

	if playerColor == 1 then
		colorName = "Red"
	elseif playerColor == 2 then
		colorName = "Blue"
	elseif playerColor == 3 then
		colorName = "Green"
	end





	love.graphics.setNewFont(30)
	love.graphics.setColor(200, 200, 200)

	string = "Color: " .. colorName .. "\n"
	string = string .. "Top Speed: " .. playerType.topSpeed .. "\n"
	string = string .. "Acceleration: " .. playerType.acceleration .. "\n"
	string = string .. "Rotation Speed: " .. playerType.rotationSpeed .. "\n"
	string = string .. "Fire Rate: " .. playerType.fireRate .. "\n"
	string = string .. "Health: " .. playerType.health .. "\n"
	string = string .. "Weapon Damage: " .. playerType.weaponDamage .. "\n"


	love.graphics.print(string, xOffset, yOffset + 80)
end


function ShipSelect.drawReady(i, player)
	love.graphics.setColor(255, 255, 255)
	love.graphics.setNewFont(60)
	local playerShip = player.ship
	local xOffset = 1920/4 * (i-1) + 100
	local yOffset = 1080/8
	love.graphics.print("Player " .. i, xOffset+30, yOffset)

	local playerColor = player.ship.color



	local yOffset = 1080/8 + 400
	love.graphics.setColor(255, 255, 255)

	love.graphics.push()
	love.graphics.scale(2,2)
	local playerShip = player.ship
	if playerShip then
		playerShip.x = (xOffset+120)/2
		playerShip.y = (yOffset-150)/2
		playerShip:draw()
	end
	love.graphics.pop()

	local playerType = player.ship.shipType
	love.graphics.print("Ready!", xOffset, yOffset - 45)
end



function ShipSelect.drawInactive(i, player)
	love.graphics.setColor(255, 255, 255)
	love.graphics.setNewFont(60)


	local xOffset = 1920/4 * (i-1) + 100
	local yOffset = 1080/8
	love.graphics.print("Player " .. i, xOffset+30, yOffset)

	local yOffset = 1080/8 + 400
	love.graphics.print("Press (A)\n  to join", xOffset, yOffset - 45)

end


return ShipSelect