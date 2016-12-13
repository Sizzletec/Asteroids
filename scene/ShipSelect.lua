ShipSelect = {}
ShipSelect.__index = ShipSelect


gKeyPressed = {}

require('object/object')
require('object/Ship')
require('object/Bullet')
require('object/MissileShot')
local t = 0

SelectStep = {
	inactive = 0,
	active = 1,
	ready = 2
}

local menuSpeed = .3

function ShipSelect.load()
	for i,player in pairs(Players) do
		s = Ship.new(player,0,0)
		s.type = ShipSelectOrder[1]
		player.ship = s

		if not player.select then
			player.select = {
				step = SelectStep.inactive,
				menuCooldown = menuSpeed,
				typeIndex = 1,
				color = i-1
			}
		end
	end
	-- Players[2].select.step = SelectStep.ready
	Players[3].select.step = SelectStep.ready
	Players[4].select.step = SelectStep.ready
end


function ShipSelect.isReadyToStart()
	local start = true
	count = 0
	for i, player in pairs(Players) do
		if player.select.step == SelectStep.active then
			start = false
		elseif player.select.step == SelectStep.ready then
			count = count + 1
		end
	end

	if count < 2 and start then
		start = false
	end

	return start
end

function ShipSelect.startGame()
	if ShipSelect.isReadyToStart() then
		setState(State.game)
	end
end

function ShipSelect.keypressed(key, unicode)
	local id = 1
	local player = Players[id]

	if player.select.step == SelectStep.inactive then
		if (key == "return") then
			player.select.step = SelectStep.active
    	end
    	if (key == "escape") then
	    	setState(State.title)
    	end
	elseif player.select.step == SelectStep.active then
		if (key == "space") then
			player.select.color = player.select.color  + 1
			if player.select.color  > 3 then
				player.select.color  = 0
			end
	    end

	    if (key == "return") then
	    	player.select.step = SelectStep.ready
    	end

    	if (key == "escape") then
	    	player.select.step = SelectStep.inactive
    	end

	   	if (key == "left") then
	    	ShipSelect.shipLeft(id)
		end
		if (key == "right") then
			ShipSelect.shipRight(id)

		end
    elseif player.select.step == SelectStep.ready then
    	if (key == "escape") then
	    	player.select.step = SelectStep.active
    	end

    	if (key == "return") then
	    	ShipSelect.startGame()
    	end
	end
end

function ShipSelect.shipLeft(id)
	local player = Players[id]
	player.select.typeIndex = player.select.typeIndex - 1

	if player.select.typeIndex < 1 then
		player.select.typeIndex = #ShipSelectOrder
	end

	if player.ship then
  		player.ship.shipType = ShipSelectOrder[player.select.typeIndex]
  		player.ship:setDefaults()
	end
end

function ShipSelect.shipRight(id)
	local player = Players[id]
	player.select.typeIndex = player.select.typeIndex + 1

	if player.select.typeIndex > #ShipSelectOrder then
		player.select.typeIndex = 1
	end

	if player.ship then
  		player.ship.shipType = ShipSelectOrder[player.select.typeIndex]
  		player.ship:setDefaults()
	end
end

function ShipSelect.gamepadpressed(joystick, button)
	local id, instanceid = joystick:getID()
	local player = Players[id]

	if player.select.step  == SelectStep.inactive then
		if button == "a" then
			player.select.step = SelectStep.active
    	end
    	if button == "b" then
	    	setState(State.title)
    	end

	elseif player.select.step  == SelectStep.active then
	
		if button == "dpleft" then 
	    	ShipSelect.shipLeft(id)
		elseif button == "dpright" then
			ShipSelect.shipRight(id)
		end

		if button == "x" or button == "y" then
	    	player.select.color = player.select.color  + 1
			if player.select.color  > 3 then
				player.select.color  = 0
			end
	    end

	    if button == "a" then
	    	player.select.step = SelectStep.ready
    	end
    	if button == "b" then
	    	player.select.step = SelectStep.inactive
    	end
    elseif player.select.step == SelectStep.ready then
    	if button == "b" then
    		player.select.step = SelectStep.active
    	end
	end

    if button == "start" then
    	ShipSelect.startGame()
    end
end


function ShipSelect.gamepadaxis(joystick, axis, value)
	local id, instanceid = joystick:getID()
	local player = Players[id]

	if axis ==  "leftx" and player.select.menuCooldown <= 0 and player.select.step == SelectStep.active then

		if value > 0.9 then
			ShipSelect.shipRight(id)
			player.select.menuCooldown = menuSpeed
		elseif value < -0.9 then
			ShipSelect.shipLeft(id)
			player.select.menuCooldown = menuSpeed
		end 
	end
end

function ShipSelect.update(dt)
	for i, player in pairs(Players) do
		if player.select.menuCooldown > 0 then
			player.select.menuCooldown = player.select.menuCooldown - dt
		end
		if player.select.step == SelectStep.active then
			ShipSelect.updateActive(i, player, dt)
		elseif player.step == SelectStep.ready then
			ShipSelect.updateReady(i, player, dt)
		end
		player.ship.components.render.color = player.select.color
	end
	t = t + dt
	if t > 4 then
		t = t - 4
	end
end

function ShipSelect.draw()
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()

	scaleFactor = width/1920

	love.graphics.scale(scaleFactor, scaleFactor)

	img:setWrap("repeat", "repeat")
	quad = love.graphics.newQuad(0,0, width,height, 200, 300)
	love.graphics.draw(img,quad,0, 0, 0,4,4 )


	for i, player in pairs(Players) do
		if player.select.step == SelectStep.active then
			ShipSelect.drawActive(i, player)
		elseif player.select.step == SelectStep.inactive then
			ShipSelect.drawInactive(i, player)
		elseif player.select.step == SelectStep.ready then
			ShipSelect.drawReady(i, player)
		end
	end

	if ShipSelect.isReadyToStart() then
		love.graphics.print("All Ready! Press start to...?",500, 960)
	end
end

function ShipSelect.updateActive(i, player, dt)
	player.ship:update(dt)
	if t > 3 then
		player.ship.components.input.throttle = 1
		player.ship.components.input.primary = false
		player.ship.components.input.secondary = true
	elseif t > 2 then
		player.ship.components.input.secondary = false
		player.ship.components.input.primary = true
	else
		player.ship.components.input.secondary = false
		player.ship.components.input.primary = false
		player.ship.components.input.throttle = 0
	end

	if not player.ship.engine then
		player.ship.components.move.rotation = player.ship.components.move.rotation + 2 * dt
	end
end


function ShipSelect.updateReady(i, player, dt)
	player.ship.engine = false
	player.ship.firing = false
	player.ship.components.move.rotation = player.ship.components.move.rotation - 1 * dt
	player.ship:update(dt)
end

function ShipSelect.drawActive(i, player)
	love.graphics.setColor(255, 255, 255)
	love.graphics.setNewFont(60)
	local playerShip = player.ship
	local xOffset = 1920/4 * (i-1) + 100
	local yOffset = 1080/8
	love.graphics.print("Player " .. i, xOffset+30, yOffset)

	local playerColor = player.ship.components.render.color
	local yOffset = 1080/8 + 400

	love.graphics.setColor(255, 255, 255)
	love.graphics.polygon("fill", xOffset-30, yOffset+30, xOffset-30, yOffset-30, xOffset-60, yOffset)

	local triOffset = 1920/4 * i - 40
	love.graphics.polygon("fill", triOffset-30, yOffset+30, triOffset-30, yOffset-30, triOffset, yOffset)

	love.graphics.push()
	love.graphics.scale(2,2)
	local playerShip = player.ship
	if playerShip then
		playerShip.components.move.x = (xOffset+120)/2
		playerShip.components.move.y = (yOffset-150)/2
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

	-- local weapon = player.ship.components.primary

	string = "Color: " .. colorName .. "\n"
	string = string .. "Top Speed: " .. playerType.topSpeed .. "\n"
	string = string .. "Acceleration: " .. playerType.acceleration .. "\n"
	string = string .. "Rotation Speed: " .. playerType.rotationSpeed .. "\n"
	-- string = string .. "Fire Rate: " .. weapon.fireRate .. "\n"
	string = string .. "Health: " .. playerType.health .. "\n"
	-- string = string .. "Weapon Damage: " .. weapon.weaponDamage .. "\n"

	love.graphics.print(string, xOffset, yOffset + 80)
end

function ShipSelect.drawReady(i, player)
	love.graphics.setColor(255, 255, 255)
	love.graphics.setNewFont(60)
	local playerShip = player.ship
	local xOffset = 1920/4 * (i-1) + 100
	local yOffset = 1080/8
	love.graphics.print("Player " .. i, xOffset+30, yOffset)

	local playerColor = player.ship.components.render.color

	local yOffset = 1080/8 + 400
	love.graphics.setColor(255, 255, 255)

	love.graphics.push()
	love.graphics.scale(2,2)
	local playerShip = player.ship
	if playerShip then
		playerShip.components.move.x = (xOffset+120)/2
		playerShip.components.move.y = (yOffset-150)/2

		playerShip:draw()
	end
	love.graphics.pop()
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