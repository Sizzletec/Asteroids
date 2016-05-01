Game = {}
Game.__index = Game

love.filesystem.load("maps/tiledmap.lua")()

require('object/Ship')
require('object/Bullet')
require('object/MissileShot')

local myShader = love.graphics.newShader( "shaders/lighting.glsl" )

gKeyPressed = {}

local players = {}

gCamX,gCamY = 0,0

local numberAlive = 0
local gameWon = false
local winCount = 10

function Game.load()
	players = {}
	-- math.randomseed(os.time())
	local level = "maps/arena" .. tostring(love.math.random(4)) .. ".tmx"
	TiledMap_Load(level,16)

	spawn = TiledMap_GetSpawnLocations()


	for i, player in pairs(selections) do
		playerShip = player.ship
		if playerShip then
			
			playerShip:setDefaults()
			playerShip:spawn()
			table.insert(players, playerShip)
		end
	end
	numberAlive = table.getn(players)
	gameWon = false
	winCount = 8
end

function Game.getPlayers()
	return players
end

function Game.GetSpawnLocation()
	local newSpawn = {x = 100, y = 100, r = 0}

	playerCount = table.getn(players)

	anyoneAlive = false
	for p, player in pairs(players) do
		if player.components.life.alive then
			anyoneAlive =true
		end
	end

	if playerCount == 0 or not anyoneAlive then
		newSpawn = {x = spawn[1].x, y = spawn[1].y, r = spawn[1].r}
	else
		local bestDistance = 0

		for l, location in pairs(spawn) do
			local compDist
			for p, player in pairs(players) do
				if player.components.life.alive then
					xPow = math.pow(player.components.move.x - location.x, 2)
					yPow = math.pow(player.components.move.y - location.y, 2)

					local dist = math.sqrt(xPow + yPow)
					if not compDist then
						compDist = dist
					elseif dist < compDist then
						compDist = dist
					end
				end
			end

			if compDist >= bestDistance then
				bestDistance = compDist
				newSpawn = {x = location.x, y = location.y, r = location.r}
			end
		end
	end
	return newSpawn
end

function Game.keyreleased(key)
	for _, player in pairs(players) do
		local keyboard = player.components.keyboard
		if keyboard ~= nil then
			keyboard:keyreleased(key)
		end
	end
end

function Game.keypressed(key, unicode)
	if (key == "escape") then setState(State.shipSelect) end
	for _, player in pairs(players) do
		local keyboard = player.components.keyboard
		if keyboard ~= nil then
			keyboard:keypressed(key, unicode)
		end
	end
end

-- function Game.gamepadpressed(joystick, button)
-- 	local id, instanceid = joystick:getID()
-- 	local player = Game.getPlayer(id)
-- 	if player then
-- 	    if button == "a" then
-- 	    	player.firing = true
-- 	    end

-- 	    if button == "y" then
-- 	    	player:selfDestruct()
-- 	    end
-- 	end
-- end

-- function Game.gamepadreleased(joystick, button)
-- 	local id, instanceid = joystick:getID()
-- 	local player = Game.getPlayer(id)
-- 	if player then
-- 	    if button == "a" then
-- 	    	player.firing = false
-- 	    end
-- 	end
-- end

-- function Game.gamepadaxis(joystick, axis, value)

-- end

function Game.getPlayer(id)
	for i, player in pairs(players) do
		if player.player == id then
			return player
		end
	end
end

function Game.checkWin()
	for i, player in pairs(players) do
		if player.components.life.lives == 0 then
			if not player.place then
				player.place = numberAlive
				numberAlive = numberAlive - 1
			end
		end
	end
	if numberAlive == 1 then
		for i, player in pairs(players) do
			if player.components.life.lives > 0 then
				player.place = numberAlive
			end
			selections[player.player].ship = player
		end
		gameWon = true
	end
end

function Game.update(dt)

	if gameWon then
		winCount = winCount - 3 * dt
		dt = dt / winCount

		if winCount <= 1 then
			setState(State.score)
		end
	end

	for i, player in pairs(players) do
		local joysticks = love.joystick.getJoysticks()
		local joy = joysticks[player.player]

		if joy then
			-- local joyX = joy:getGamepadAxis("leftx")
			-- local throttle = joy:getGamepadAxis("triggerright")


			joyX = joy:getGamepadAxis("leftx")
			joyY = joy:getGamepadAxis("lefty")

			if math.abs(joyX) > 0.5 or math.abs(joyY) > 0.5 then
				Mover.MoveTowards(player,joyX,joyY,dt)
			end

			if player.shipType == ShipType.gunship then
				joyCannonX = joy:getGamepadAxis("rightx")
				joyCannonY = joy:getGamepadAxis("righty")

				if math.abs(joyCannonX) > 0.5 or math.abs(joyCannonY) > 0.5 then
					local angle = math.atan2(joyCannonX,-joyCannonY)

					player.cannonRotation = angle
					player.firing = true
				end
			end
		end

		player:update(dt)

		for b, bullet in pairs(player.bullets) do
		    local hitWall = TiledMap_GetMapTile(math.floor(bullet.x/16),math.floor(bullet.y/16),1)
		    if hitWall > 0 and (not bullet.bounce) then
		    	table.remove(player.bullets, b)
		    else
				for p, otherPlayer in pairs(players) do
					if player ~= otherPlayer and otherPlayer.components.life.alive then
						xPow = math.pow(otherPlayer.components.move.x - bullet.x, 2)
						yPow = math.pow(otherPlayer.components.move.y - bullet.y, 2)

						dist = math.sqrt(xPow + yPow)

						if dist < 20 then
							player.components.score.hits = player.components.score.hits + 1
							otherPlayer.components.life:takeDamage(player, bullet.damage)
							table.remove(player.bullets, b)
						end
					end
			   end
			end
		end
	end
	Game.checkWin()
end

function Game.draw()
	love.graphics.setShader(myShader)

	width = love.graphics.getWidth()
	height = love.graphics.getHeight()

	scaleFactor = width/1920

	myShader:send("numLights",table.getn(players))

	lights = {}
	for i, player in pairs(players) do
		local pos  = {player.components.move.x*scaleFactor,player.components.move.y*scaleFactor}
		table.insert(lights,pos)
	end

	myShader:send("lightArray", lights[1],lights[2],lights[3],lights[4])

	love.graphics.scale(scaleFactor, scaleFactor)

	gCamX,gCamY = width/2,height/2
	TiledMap_AllAtCam(gCamX,gCamY)
	love.graphics.setNewFont(40)
	for i, player in pairs(players) do
		love.graphics.setShader(myShader)
		player:draw()

		local xOffset = 1920/4 * (i-1) + 100
		love.graphics.setShader()
		player:drawLifeMarkers(xOffset+10,994)

		if player.components.life.lives > 0 then
			love.graphics.print(player.components.life.health .. " hp", xOffset+30, 1016)
		end

	end
	Bullet.draw()
	MissileShot.draw()
	-- Beam.draw()
	-- fps = love.timer.getFPS()
    -- love.graphics.print(winCount, 50, 50)
	love.graphics.setBackgroundColor(0x20,0x20,0x20)
end

return Game