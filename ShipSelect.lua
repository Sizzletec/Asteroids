ShipSelect = {}
ShipSelect.__index = ShipSelect


gKeyPressed = {}

local Ship = require('Ship')
local Bullet = require('Bullet')
local t = 0

SelectStep = {
	inactive = 0,
	active = 1,
	confirm = 2,
	ready = 3
}

selections = {
 	{
		step = SelectStep.inactive
	},
	{
		step = SelectStep.inactive
	},
	{
		step = SelectStep.inactive
	},
	{
		step = SelectStep.inactive
	}
}

function ShipSelect.load()
	selections[1].step = SelectStep.active
	selections[1].ship = Ship.new(1,0,0)

	selections[2].step = SelectStep.active
	selections[2].ship = Ship.new(1,0,0)

	selections[3].step = SelectStep.active
	selections[3].ship = Ship.new(1,0,0)

	selections[4].step = SelectStep.active
	selections[4].ship = Ship.new(1,0,0)
end

function ShipSelect.keyreleased(key)
	gKeyPressed[key] = nil
end


function ShipSelect.keypressed(key, unicode)
	gKeyPressed[key] = true
	if (key == "escape") then setState(State.title) end
	if (key == "return") then setState(State.game) end
    if (key == "left") then
		ship = selections[1].ship
		if ship then
			if ship.shipType == ShipType.standard then
				selections[1].ship.shipType = ShipType.gunship
			elseif ship.shipType == ShipType.gunship then
				selections[1].ship.shipType = ShipType.assalt
			else
				selections[1].ship.shipType = ShipType.standard
			end
		end
	end
	if (key == "right") then
		ship = selections[1].ship
		if ship then
			if ship.shipType == ShipType.standard then
				selections[1].ship.shipType = ShipType.assalt
			elseif ship.shipType == ShipType.assalt then
				selections[1].ship.shipType = ShipType.gunship
			else
				selections[1].ship.shipType = ShipType.standard
			end
		end
	end
end

function ShipSelect.gamepadpressed(joystick, button)
    if button == "a" then
    	setState(State.game)
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
			if t > 2 then
				-- player.ship.firing = true
			else
				player.ship.firing = false
			end

		if player.ship then
			player.ship.rotation = player.ship.rotation + 2 * dt
		end
		player.ship:update(dt)
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
		love.graphics.setColor(255, 255, 255)
		love.graphics.setNewFont(60)
		xOffset = 1920/4 * (i-1) + 100
		yOffset = 1080/8
		love.graphics.print("Player " .. i, xOffset+30, yOffset)

		yOffset = 1080/8 + 400
		love.graphics.setColor(255, 255, 255)
		love.graphics.polygon("fill", xOffset-30, yOffset+30, xOffset-30, yOffset-30, xOffset-60, yOffset)

		triOffset = 1920/4 * i - 40
		love.graphics.polygon("fill", triOffset-30, yOffset+30, triOffset-30, yOffset-30, triOffset, yOffset)


		love.graphics.scale(2,2)
		playerShip = player.ship
		if playerShip then
			playerShip.x = (xOffset+120)/2
			playerShip.y = (yOffset-150)/2
			playerShip:draw()
		end
		love.graphics.scale(0.5, 0.5)

		playerType = player.ship.shipType
		love.graphics.print(playerType.name, xOffset, yOffset - 45)

 		love.graphics.setNewFont(30)

 		love.graphics.setColor(200, 200, 200)

		love.graphics.print("Top Speed: " .. playerType.topSpeed, xOffset, yOffset + 50)
		love.graphics.print("Acceleration: " .. playerType.acceleration, xOffset, yOffset + 110)
		love.graphics.print("Rotation Speed: " .. playerType.rotationSpeed, xOffset, yOffset + 170)
		love.graphics.print("Fire Rate: " .. playerType.fireRate, xOffset, yOffset + 230)
		love.graphics.print("Health: " .. playerType.health, xOffset, yOffset + 290)
		love.graphics.print("Weapon Damage: " .. playerType.weaponDamage, xOffset, yOffset + 350)
	end

	for i, player in pairs(selections) do

		bullets = table.getn(player.ship.bullets)
		love.graphics.print(bullets, 50, 100*i+30)
	end


	love.graphics.setBackgroundColor(0x20,0x20,0x20)
end

return ShipSelect