Game = {}
Game.__index = Game

love.filesystem.load("tiledmap.lua")()

local Ship = require('Ship')
local Bullet = require('weapons/Bullet')
local Beam = require('weapons/Beam')
local missileShot = require('weapons/MissileShot')

local myShader = love.graphics.newShader[[
	extern number numLights;
	extern vec2 lightArray[4];

    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
		vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
		int count = 0;
		lightArray;
		bool lit = false;
		while(count < numLights){

			vec2 ship = lightArray[count];

			float dist = distance(ship,screen_coords);

			  if(dist < 400){
			  	lit = true;
			  }
			count++;
		}

		if(!lit){
		  	pixel.r = pixel.r - 0.3;
			pixel.g = pixel.g - 0.3;
			pixel.b = pixel.b - 0.3;

		}
		return pixel;
    }
  ]]

gKeyPressed = {}

local players = {}

gCamX,gCamY = 0,0

local keyboardPlayer

spawn = {}

local numberAlive = 0

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

			local spawnLocation = Game.GetSpawnLocation()
			playerShip.x = spawnLocation.x
			playerShip.y = spawnLocation.y
			playerShip.rotation = math.rad(spawnLocation.r)
			table.insert(players, playerShip)

			if playerShip.player == 1 then
				keyboardPlayer = playerShip
			end
		end
	end
	numberAlive = table.getn(players)
end

function Game.getPlayers()
	return players
end

function Game.GetSpawnLocation()
	local newSpawn = {x = 100, y = 100, r = 0}

	playerCount = table.getn(players)

	anyoneAlive = false
	for p, player in pairs(players) do
		if not player.exploding then
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
				if not player.exploding then
					xPow = math.pow(player.x - location.x, 2)
					yPow = math.pow(player.y - location.y, 2)

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
	gKeyPressed[key] = nil
	if keyboardPlayer then
		if (key == "space") then
			keyboardPlayer.firing = false
		end
	end
end

function Game.keypressed(key, unicode)
	gKeyPressed[key] = true
	if (key == "escape") then setState(State.shipSelect) end

	if keyboardPlayer then
		if (key == "space") then
			keyboardPlayer.firing = true
		end

		if (key == "y") then
	    	keyboardPlayer:selfDestruct()
	    end
	end
end

function Game.gamepadpressed(joystick, button)
	local id, instanceid = joystick:getID()
	local player = Game.getPlayer(id)
	if player then
	    if button == "a" then
	    	player.firing = true
	    end

	    if button == "y" then
	    	player:selfDestruct()
	    end
	end
end

function Game.gamepadreleased(joystick, button)
	local id, instanceid = joystick:getID()
	local player = Game.getPlayer(id)
	if player then
	    if button == "a" then
	    	player.firing = false
	    end
	end
end

function Game.gamepadaxis(joystick, axis, value)

end

function Game.getPlayer(id)
	for i, player in pairs(players) do
		if player.player == id then
			return player
		end
	end
end

function Game.checkWin()
	for i, player in pairs(players) do
		if player.lives == 0 then
			if not player.place then
				player.place = numberAlive
				numberAlive = numberAlive - 1
			end
		end
	end
	if numberAlive == 1 then
		for i, player in pairs(players) do

			if player.lives > 0 then
				player.place = numberAlive
			end
			selections[player.player].ship = player
		end
		setState(State.score)
	end
end

function Game.update(dt)
	if keyboardPlayer then
		if (gKeyPressed.lshift) then
			keyboardPlayer.shield = true
		else
			keyboardPlayer.shield = false
		end
		-- local leftDown = love.mouse.isDown(1)
		-- if leftDown then
		-- 	scaleFactor = width/1920

		-- 	x, y = love.mouse.getPosition( )
		-- 	Mover.MoveTowards(keyboardPlayer,x*scaleFactor,y*scaleFactor,dt)
		-- end
		if (gKeyPressed.up) then
			keyboardPlayer.throttle = 1
		end

		if (gKeyPressed.left) then
			keyboardPlayer.angularInput = -1
		end

		if (gKeyPressed.right) then
			keyboardPlayer.angularInput = 1
		end
	end
 

	for i, player in pairs(players) do
		local joysticks = love.joystick.getJoysticks()
		local joy = joysticks[player.player]

		if joy then
			-- local joyX = joy:getGamepadAxis("leftx")
			-- local throttle = joy:getGamepadAxis("triggerright")

			if keyboardPlayer.player ==  player.player then
				if not gKeyPressed.up then
					player.throttle = throttle
				end
			else
				player.throttle = throttle
			end


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

		local s = 0
		player:update(dt)

		for b, bullet in pairs(player.bullets) do
		    local hitWall = TiledMap_GetMapTile(math.floor(bullet.x/16),math.floor(bullet.y/16),1)
		    if hitWall > 0 then
		    	table.remove(player.bullets, b)
		    else
				for p, otherPlayer in pairs(players) do
					if player ~= otherPlayer and not otherPlayer.exploding then
						xPow = math.pow(otherPlayer.x - bullet.x, 2)
						yPow = math.pow(otherPlayer.y - bullet.y, 2)

						dist = math.sqrt(xPow + yPow)

						if dist < 20 then
							player.hits = player.hits + 1
							if bullet.damage >= otherPlayer.health then
								if otherPlayer.health ~= 0 then
									player.kills = player.kills + 1
								end
								player.damageGiven = player.damageGiven + otherPlayer.health

								otherPlayer.damageTaken = otherPlayer.damageTaken + otherPlayer.health
							else
								player.damageGiven = player.damageGiven + bullet.damage 
								otherPlayer.damageTaken = otherPlayer.damageTaken + bullet.damage 
							end

							otherPlayer.health = otherPlayer.health - bullet.damage

							if otherPlayer.health < 0 then
								otherPlayer.health = 0
							end
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
	love.graphics.setShader(myShader) --draw something here

	width = love.graphics.getWidth()
	height = love.graphics.getHeight()

	scaleFactor = width/1920

	myShader:send("numLights",table.getn(players))

	lights = {}
	for i, player in pairs(players) do
		local pos  = {player.x*scaleFactor,player.y*scaleFactor}
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

		if player.lives > 0 then
			love.graphics.print(player.health .. " hp", xOffset+30, 1016)
		end

	end
	Bullet.draw()
	MissileShot.draw()
	-- Beam.draw()
	-- fps = love.timer.getFPS()
    -- love.graphics.print(keyboardPlayer.rotation, 50, 50)
	love.graphics.setBackgroundColor(0x20,0x20,0x20)
end

return Game