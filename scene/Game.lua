Game = {}
Game.__index = Game

love.filesystem.load("maps/tiledmap.lua")()

require('object/Ship')
require('object/Bullet')
require('object/MissileShot')

local myShader = love.graphics.newShader( "shaders/lighting.glsl" )
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
		local keyboard = player.components.input.components.keyboard
		if keyboard ~= nil then
			keyboard:keyreleased(key)
		end
	end
end

function Game.keypressed(key, unicode)
	if (key == "escape") then setState(State.shipSelect) end
	for _, player in pairs(players) do
		local keyboard = player.components.input.components.keyboard
		if keyboard ~= nil then
			keyboard:keypressed(key, unicode)
		end
	end
end

function Game.gamepadpressed(joystick, button)
	local id, instanceid = joystick:getID()
	local player = Game.getPlayer(id)
	if player then
		local joystick = player.components.input.components.joystick
		if joystick ~= nil then
			joystick:gamepadpressed(joystick, button)
		end
	end
end

function Game.gamepadreleased(joystick, button)
	local id, instanceid = joystick:getID()
	local player = Game.getPlayer(id)
	if player then
		local joystick = player.components.input.components.joystick
		if joystick ~= nil then
			joystick:gamepadreleased(joystick, button)
		end
	end
end

function Game.gamepadaxis(joystick, axis, value)
	local id, instanceid = joystick:getID()
	local player = Game.getPlayer(id)
	if player then
		local joystick = player.components.input.components.joystick
		if joystick ~= nil then
			joystick:gamepadaxis(joystick, axis, value)
		end
	end
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
		player:update(dt)
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

	myShader:send("lightArray", lights[1],lights[2])

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